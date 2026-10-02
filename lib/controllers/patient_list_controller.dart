import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';
import '../models/response/doctors/statewise_patient_count_response.dart';
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

  // Dynamic counts for status tabs from get_no_of_patients API
  final RxString referCount = '0'.obs;
  final RxString instituteCount = '0'.obs;
  final RxString inProcessCount = '0'.obs;
  final RxString onHoldCount = '0'.obs;
  final RxString servedCount = '0'.obs;
  final RxString referOutCount = '0'.obs;
  final RxString scheduleTodayCount = '0'.obs;
  final RxString scheduleMissedCount = '0'.obs;
  final RxString scheduleImpCount = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    _loadDoctorName().then((_) {
      fetchPatientCounts();
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

  /// Fetches status counts from api/v2/Doctor/get_no_of_patients
  Future<void> fetchPatientCounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (doctorId.isEmpty) return;

      final response = await apiClient.post(
        ApiEndpoints.getNoOfPatients,
        data: {'doctor_id': doctorId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final countRes = StatewisePatientCountResponse.fromJson(response.data);
        if (countRes.status == 'success') {
          referCount.value = countRes.referIn;
          inProcessCount.value = countRes.inProcess;
          onHoldCount.value = countRes.onHold;
          servedCount.value = countRes.serve;
          referOutCount.value = countRes.referOut;
          scheduleTodayCount.value = countRes.scheduleToday;
          scheduleMissedCount.value = countRes.scheduleMissed;
          scheduleImpCount.value = countRes.scheduleImp;
        }
      }
    } catch (_) {
      // Fail silently
    }
  }

  /// Fetches statuswise patients list from API
  Future<void> fetchPatients({
    bool isLoadMore = false,
    String search = '',
  }) async {
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
          }
          hasMore.value = false;
        }
      } else {
        if (!isLoadMore) {
          patients.clear();
          errorMessage.value =
              'Failed to load patients: ${response.statusCode}';
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
      AppSnackbars.showError('Error', 'Could not open dialer: $e');
    }
  }

  /// Confirms doctor consultation for a patient
  Future<bool> confirmConsultPatientPost(
    String appointmentId,
    String type,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.confirmConsultPatientPost,
        data: {'appointment_id': appointmentId, 'type': type},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final resStatus = response.data['status']?.toString() ?? '';
        final resMsg = response.data['msg']?.toString() ?? '';
        if (resStatus == 'success') {
          AppSnackbars.showSuccess(
            'Success',
            resMsg.isNotEmpty ? resMsg : 'Patient confirmed successfully.',
          );
          return true;
        } else {
          AppSnackbars.showError(
            'Error',
            resMsg.isNotEmpty ? resMsg : 'Failed to confirm patient.',
          );
          return false;
        }
      } else {
        AppSnackbars.showError('Error', 'Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Connection error: $e');
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
            final success = await confirmConsultPatientPost(
              patient.id,
              'doctor_verify',
            );
            if (success) {
              fetchPatientCounts();
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

    final fullName =
        '${patient.firstName} ${patient.midName.isNotEmpty ? '${patient.midName[0]} ' : ''}${patient.lastName}'
            .trim();

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
