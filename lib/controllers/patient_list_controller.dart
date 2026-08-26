import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';
import '../models/response/doctors/statuswise_patients_response.dart';
import '../services/api/api_client.dart';
import '../views/widgets/confirm_patient_dialog.dart';

class PatientListController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString doctorName = ''.obs;
  final RxList<PatientAppointmentData> patients =
      <PatientAppointmentData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMoreLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected status tab (Defaults to 'In Process')
  final RxString selectedStatus = 'In Process'.obs;

  // Search Text Controller
  final TextEditingController searchController = TextEditingController();

  // Scroll Controller for infinite scrolling
  late final ScrollController scrollController;

  // Pagination states
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;

  // Dynamic counts for status tabs
  final RxInt referCount = 0.obs;
  final RxInt instituteCount = 0.obs;
  final RxInt inProcessCount = 0.obs;
  final RxInt onHoldCount = 0.obs;
  final RxInt servedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    _loadDoctorName().then((_) {
      fetchPatients();
    });
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchPatients(isLoadMore: true, search: searchController.text);
    }
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
  }

  /// Fetches statuswise patients list from API
  Future<void> fetchPatients({bool isLoadMore = false, String search = ''}) async {
    if (isLoadMore) {
      if (isLoadMoreLoading.value || !hasMore.value) return;
      isLoadMoreLoading.value = true;
      currentPage.value++;
    } else {
      if (isLoading.value) return;
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = 1;
      hasMore.value = true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (doctorId.isEmpty) {
        errorMessage.value = 'Doctor ID not found. Please log in again.';
        if (!isLoadMore) patients.clear();
        return;
      }

      final response = await apiClient.post(
        ApiEndpoints.statuswisePatients,
        data: {
          'doctor_id': doctorId,
          'appointment_status': selectedStatus.value,
          'search': search,
          'page_no': currentPage.value,
          'limit': 10,
          'start': (currentPage.value - 1) * 10,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = StatuswisePatientsResponse.fromJson(response.data);
        if (res.status == 'success') {
          if (isLoadMore) {
            patients.addAll(res.data);
          } else {
            patients.assignAll(res.data);
            _updateCountForStatus(selectedStatus.value, res.data.length);
          }

          // If returned data length is less than page limit (10), we reached the end
          if (res.data.length < 10) {
            hasMore.value = false;
          }
        } else {
          if (!isLoadMore) {
            patients.clear();
            errorMessage.value = res.msg.isNotEmpty
                ? res.msg
                : 'No patients found';
            _updateCountForStatus(selectedStatus.value, 0);
          }
          hasMore.value = false;
        }
      } else {
        if (!isLoadMore) {
          patients.clear();
          errorMessage.value = 'Failed to load patients: ${response.statusCode}';
        }
        hasMore.value = false;
      }
    } catch (e) {
      if (!isLoadMore) {
        patients.clear();
        errorMessage.value = 'Connection error: $e';
      }
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadMoreLoading.value = false;
    }
  }

  void _updateCountForStatus(String status, int count) {
    if (status == 'Refer') {
      referCount.value = count;
    } else if (status == 'Institute') {
      instituteCount.value = count;
    } else if (status == 'In Process') {
      inProcessCount.value = count;
    } else if (status == 'On Hold') {
      onHoldCount.value = count;
    } else if (status == 'Served') {
      servedCount.value = count;
    }
  }

  /// Change active status tab and reload patients list
  void changeStatus(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchPatients(search: searchController.text);
    }
  }

  /// Launch dialer on phone click
  Future<void> callNumber(String number) async {
    final cleanNumber = number.replaceAll('/', '').replaceAll(' ', '').trim();
    if (cleanNumber.isEmpty) return;

    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    try {
      await launchUrl(url);
    } catch (e) {
      debugPrint('Dialer launch error: $e');
      Get.rawSnackbar(
        message: 'Could not open dialer: $e',
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Confirms doctor consultation for a patient
  Future<bool> confirmConsultPatientPost(String appointmentId, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.confirmConsultPatientPost,
        data: {
          'appointment_id': appointmentId,
          'type': type,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final resStatus = response.data['status']?.toString() ?? '';
        final resMsg = response.data['msg']?.toString() ?? '';
        if (resStatus == 'success') {
          Get.rawSnackbar(
            message: resMsg.isNotEmpty ? resMsg : 'Patient confirmed successfully.',
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          );
          return true;
        } else {
          Get.rawSnackbar(
            message: resMsg.isNotEmpty ? resMsg : 'Failed to confirm patient.',
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          );
          return false;
        }
      } else {
        Get.rawSnackbar(
          message: 'Server error: ${response.statusCode}',
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.rawSnackbar(
        message: 'Connection error: $e',
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  /// Handle view details button click
  void onViewDetails(PatientAppointmentData patient) async {
    if (patient.doctorVerify == '0') {
      Get.dialog(
        ConfirmPatientDialog(
          patient: patient,
          onConfirm: () async {
            final success = await confirmConsultPatientPost(patient.id, 'doctor_verify');
            if (success) {
              fetchPatients(search: searchController.text);
              _navigateToServingPatient(patient);
            }
          },
        ),
      );
    } else {
      _navigateToServingPatient(patient);
    }
  }

  void _navigateToServingPatient(PatientAppointmentData patient) async {
    final prefs = await SharedPreferences.getInstance();
    final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';

    final fullName = '${patient.firstName} ${patient.midName.isNotEmpty ? '${patient.midName[0]} ' : ''}${patient.lastName}'.trim();

    final gender = patient.gender == 'Male'
        ? 'M'
        : (patient.gender == 'Female' ? 'F' : 'O');

    final args = {
      'patientId': patient.patientId,
      'fullName': fullName,
      'age': patient.age,
      'gender': gender,
      'mhcId': patient.mhcId,
      'bookingId': patient.id,
      'mobileNo': patient.mobileNo,
      'note': patient.note,
      'selectTab': selectedStatus.value,
      'status': selectedStatus.value,
      'leaderName': patient.leaderName,
      'leaderMobNo': patient.leaderMobile,
      'isRefer': patient.isRefer,
      'doctor_home_service_id': patient.doctorHomeServiceId,
      'doctorId': doctorId,
      'isAdmitted': patient.isAdmitted,
      'videoUrl': patient.videoUrl,
      'clinical_form_status': patient.clinicalFormStatus,
      'medical_form_status': '1',
      'instituteId': patient.instituteName,
      'qrCode': patient.qrCode,
    };

    Get.toNamed('/serving-patient', arguments: args);
  }
}


