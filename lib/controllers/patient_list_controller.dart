import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';
import '../models/response/statuswise_patients_response.dart';
import '../services/api/api_client.dart';

class PatientListController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString doctorName = ''.obs;
  final RxList<PatientAppointmentData> patients = <PatientAppointmentData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected status tab (Defaults to 'In Process')
  final RxString selectedStatus = 'In Process'.obs;

  // Search Text Controller
  final TextEditingController searchController = TextEditingController();

  // Dynamic counts for status tabs
  final RxInt referCount = 0.obs;
  final RxInt instituteCount = 0.obs;
  final RxInt inProcessCount = 0.obs;
  final RxInt onHoldCount = 0.obs;
  final RxInt servedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDoctorName().then((_) {
      fetchPatients();
    });
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
  }

  /// Fetches statuswise patients list from API
  Future<void> fetchPatients({String search = ''}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (doctorId.isEmpty) {
        errorMessage.value = 'Doctor ID not found. Please log in again.';
        patients.clear();
        return;
      }

      final response = await apiClient.post(
        'api/v2/Doctor/statuswise_patients',
        data: {
          'doctor_id': doctorId,
          'appointment_status': selectedStatus.value,
          'search': search,
          'page_no': 1,
          'limit': 10,
          'start': 0,
        },
        options: dio.Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = StatuswisePatientsResponse.fromJson(response.data);
        if (res.status == 'success') {
          patients.assignAll(res.data);
          _updateCountForStatus(selectedStatus.value, res.data.length);
        } else {
          patients.clear();
          errorMessage.value = res.msg.isNotEmpty ? res.msg : 'No patients found';
          _updateCountForStatus(selectedStatus.value, 0);
        }
      } else {
        patients.clear();
        errorMessage.value = 'Failed to load patients: ${response.statusCode}';
      }
    } catch (e) {
      patients.clear();
      errorMessage.value = 'Connection error: $e';
    } finally {
      isLoading.value = false;
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
}
