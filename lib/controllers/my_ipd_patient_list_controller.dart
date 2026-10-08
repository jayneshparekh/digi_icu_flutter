import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/doctors/my_ipd_patient_list_request.dart';
import 'package:digi_icu_flutter/models/response/doctors/my_ipd_patient_list_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyIpdPatientListController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString doctorName = ''.obs;
  final RxString doctorId = ''.obs;
  final RxString instituteId = ''.obs;

  final RxList<MyIpdPatientListItem> patients = <MyIpdPatientListItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMoreLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  // Selected Status Tab (Admitted, Refer, Death, Final Discharge)
  final RxString selectedStatus = 'Admitted'.obs;

  // Search Text Controller
  final TextEditingController searchController = TextEditingController();

  // Scroll Controller for Infinite Scrolling
  late final ScrollController scrollController;

  // Pagination fields
  int _start = 0;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    _loadDoctorData().then((_) {
      fetchPatients();
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadMoreLoading.value && hasMore.value && !isLoading.value) {
        fetchPatients(isLoadMore: true);
      }
    }
  }

  Future<void> _loadDoctorData() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
    doctorId.value = prefs.getString(AppConstants.prefUserId) ?? '';

    // Retrieve instituteId passed in Get.arguments or fallback to SharedPreferences
    final args = Get.arguments;
    if (args is Map && args.containsKey('institute_id')) {
      instituteId.value = args['institute_id']?.toString() ?? '';
    } else {
      instituteId.value = prefs.getString('institute_id') ?? '';
    }
  }

  /// Fetches IPD patients list with search, status filter, and pagination
  Future<void> fetchPatients({
    bool isLoadMore = false,
    String? customSearch,
  }) async {
    final search = customSearch ?? searchController.text.trim();

    if (isLoadMore) {
      if (isLoadMoreLoading.value || !hasMore.value) {
        return;
      }
      isLoadMoreLoading.value = true;
      _start += _limit;
    } else {
      if (isLoading.value) {
        return;
      }
      isLoading.value = true;
      errorMessage.value = '';
      _start = 0;
      hasMore.value = true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final docId = doctorId.value.isNotEmpty
          ? doctorId.value
          : (prefs.getString(AppConstants.prefUserId) ?? '');

      if (docId.isEmpty) {
        errorMessage.value = 'Doctor ID not found. Please log in again.';
        if (!isLoadMore) {
          patients.clear();
        }
        return;
      }

      final req = MyIpdPatientListRequest(
        doctorId: docId,
        instituteId: instituteId.value,
        status: selectedStatus.value,
        search: search,
        limit: _limit,
        start: _start,
      );

      final response = await apiClient.post(
        ApiEndpoints.ipdPatientsList,
        data: req.toJson(),
        options: dio.Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }

        if (rawData is Map<String, dynamic>) {
          final res = MyIpdPatientListResponse.fromJson(rawData);
          if (res.status == 'success' && res.data.isNotEmpty) {
            if (isLoadMore) {
              patients.addAll(res.data);
            } else {
              patients.assignAll(res.data);
            }

            if (res.data.length < _limit) {
              hasMore.value = false;
            }
          } else {
            if (!isLoadMore) {
              patients.clear();
            }
            hasMore.value = false;
          }
        } else {
          if (!isLoadMore) {
            patients.clear();
          }
          hasMore.value = false;
        }
      } else {
        if (!isLoadMore) {
          patients.clear();
          errorMessage.value = 'failed_to_load_ipd_patients'.tr;
        }
        hasMore.value = false;
      }
    } catch (e) {
      if (!isLoadMore) {
        patients.clear();
        errorMessage.value = 'failed_to_load_ipd_patients'.tr;
      }
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadMoreLoading.value = false;
    }
  }

  /// Change active status tab (Admitted, Refer, Death, Final Discharge)
  void changeStatus(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      _start = 0;
      fetchPatients();
    }
  }

  /// Performs search on text submit / search button click
  void performSearch() {
    _start = 0;
    fetchPatients();
  }

  /// Refreshes current list and resets pagination
  void refreshList() {
    _start = 0;
    fetchPatients();
  }

  /// Launch dialer on phone number tap
  Future<void> callNumber(String number) async {
    final cleanNumber = number.replaceAll('/', '').replaceAll(' ', '').trim();
    if (cleanNumber.isEmpty) {
      return;
    }

    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    try {
      await launchUrl(url);
    } catch (e) {
      AppSnackbars.showError('error'.tr, 'Could not open dialer: $e');
    }
  }

  /// Handles IPD Dashboard button click (placeholder)
  void onDashboardClick(MyIpdPatientListItem patient) {
    AppSnackbars.showInfo(
      'ipd_dashboard'.tr,
      '${'coming_soon'.tr} (${patient.patientName})',
    );
  }

  /// Handles Discharge Summary button click
  void onDischargeSummaryClick(MyIpdPatientListItem patient) {
    Get.toNamed(
      '/discharge-summary',
      arguments: {
        'admitId': patient.admitId,
        'patientId': patient.patientId,
        'appointmentId': patient.appointmentId,
        'patientName': patient.patientName,
        'age': patient.age,
        'gender': patient.gender,
        'mhcId': patient.mhcId,
        'diagnosis': patient.diagnosis,
        'instituteId': patient.instituteId,
      },
    );
  }

  /// Handles Discharge Request button click (placeholder)
  void onDischargeRequestClick(MyIpdPatientListItem patient) {
    AppSnackbars.showInfo(
      'discharge_request'.tr,
      '${'coming_soon'.tr} (${patient.patientName})',
    );
  }
}
