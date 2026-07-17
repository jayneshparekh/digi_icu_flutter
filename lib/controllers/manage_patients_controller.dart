import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';
import '../models/response/doctors/get_patient_list_response.dart';
import '../services/api/api_client.dart';

class ManagePatientsController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxList<PatientData> patients = <PatientData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMoreLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search input field controller
  final TextEditingController searchController = TextEditingController();

  // Scroll Controller for infinite scrolling detection
  late final ScrollController scrollController;

  // Total patient count
  final RxInt totalPatientsCount = 0.obs;

  final RxString doctorName = ''.obs;
  final RxString doctorId = ''.obs;
  final RxString userType = ''.obs;

  // Pagination states
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    _loadDoctorPrefs();
    fetchPatients();
  }

  Future<void> _loadDoctorPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
    doctorId.value = prefs.getString(AppConstants.prefUserId) ?? '';
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (searchController.text.trim().isNotEmpty) {
        searchPatients(isLoadMore: true);
      } else {
        fetchPatients(isLoadMore: true);
      }
    }
  }

  /// Load patients using get_patient_list API (supports pagination)
  Future<void> fetchPatients({bool isLoadMore = false}) async {
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
        patients.clear();
        return;
      }

      final response = await apiClient.post(
        ApiEndpoints.getPatientList,
        data: {'doctor_id': doctorId, 'page_no': currentPage.value},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = GetPatientListResponse.fromJson(response.data);
        if (res.status == 'success') {
          if (isLoadMore) {
            patients.addAll(res.data);
          } else {
            patients.assignAll(res.data);
            totalPatientsCount.value = res.count;
          }

          // If returned data length is less than page limit (20), we reached the end
          if (res.data.length < 20) {
            hasMore.value = false;
          }
        } else {
          if (!isLoadMore) {
            patients.clear();
            totalPatientsCount.value = 0;
            errorMessage.value = res.msg.isNotEmpty
                ? res.msg
                : 'No patients found';
          }
          hasMore.value = false;
        }
      } else {
        if (!isLoadMore) {
          patients.clear();
          totalPatientsCount.value = 0;
          errorMessage.value =
              'Failed to load patients: ${response.statusCode}';
        }
        hasMore.value = false;
      }
    } catch (e) {
      if (!isLoadMore) {
        patients.clear();
        totalPatientsCount.value = 0;
        errorMessage.value = 'Connection error: $e';
      }
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadMoreLoading.value = false;
    }
  }

  /// Perform patient search using the Admin search API (supports pagination)
  Future<void> searchPatients({bool isLoadMore = false}) async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      fetchPatients();
      return;
    }

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
      final userType = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.search,
        data: {
          'search': query,
          'type': 'Patient',
          'user_id': doctorId,
          'user_type': userType,
          'page_no': currentPage.value,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = GetPatientListResponse.fromJson(response.data);
        if (res.status == 'success') {
          if (isLoadMore) {
            patients.addAll(res.data);
          } else {
            patients.assignAll(res.data);
            totalPatientsCount.value =
                res.data.length; // Search API doesn't return count field
          }

          // If returned data length is less than page limit (20), we reached the end
          if (res.data.length < 20) {
            hasMore.value = false;
          }
        } else {
          if (!isLoadMore) {
            patients.clear();
            totalPatientsCount.value = 0;
            errorMessage.value = res.msg.isNotEmpty
                ? res.msg
                : 'No matching patients found';
          }
          hasMore.value = false;
        }
      } else {
        if (!isLoadMore) {
          patients.clear();
          totalPatientsCount.value = 0;
          errorMessage.value = 'Search failed: ${response.statusCode}';
        }
        hasMore.value = false;
      }
    } catch (e) {
      if (!isLoadMore) {
        patients.clear();
        totalPatientsCount.value = 0;
        errorMessage.value = 'Connection error: $e';
      }
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadMoreLoading.value = false;
    }
  }

  /// Clear search text and reload patient list
  void refreshList() {
    searchController.clear();
    fetchPatients();
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

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}


