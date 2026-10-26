import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/user/final_discharge_leader_request.dart';
import 'package:digi_icu_flutter/models/request/user/get_discharge_data_request.dart';
import 'package:digi_icu_flutter/models/response/doctors/check_doctor_home_response.dart';
import 'package:digi_icu_flutter/models/response/patient/discharge_request_response.dart';
import 'package:digi_icu_flutter/models/response/user/get_discharge_data_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DischargeRequestController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxBool isLoading = false.obs;
  final RxString instituteId = ''.obs;

  // Patient lists
  final RxList<DischargeRequestPatientItem> allPatients =
      <DischargeRequestPatientItem>[].obs;
  final RxList<DischargeRequestPatientItem> filteredPatients =
      <DischargeRequestPatientItem>[].obs;

  // Search input
  final TextEditingController searchController = TextEditingController();

  // Active Dialog state for clearance and discharge
  final RxBool isSubmittingDischarge = false.obs;
  final RxBool isLoadingDischargeSummary = false.obs;
  final RxString activeDischargePath = ''.obs;

  // Bill Clearance options: 'paid' or 'due'
  final RxString pharmacyBillStatus = 'paid'.obs;
  final TextEditingController pharmacyDueController = TextEditingController();

  final RxString labBillStatus = 'paid'.obs;
  final TextEditingController labDueController = TextEditingController();

  final RxString otherBillStatus = 'paid'.obs;
  final TextEditingController otherDueController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      final passedInstId = args['institute_id'] ?? args['instituteId'];
      if (passedInstId != null) {
        final val = passedInstId.toString().trim();
        if (val.isNotEmpty && val != 'null' && val != '0') {
          instituteId.value = val;
        }
      }
    }
    loadDischargeRequests();
  }

  @override
  void onClose() {
    searchController.dispose();
    pharmacyDueController.dispose();
    labDueController.dispose();
    otherDueController.dispose();
    super.onClose();
  }

  /// Ensures a valid institute_id is retrieved from state, checkDoctorHome API, or prefs
  Future<String> _resolveInstituteId() async {
    if (instituteId.value.trim().isNotEmpty &&
        instituteId.value.trim() != 'null' &&
        instituteId.value.trim() != '0') {
      return instituteId.value.trim();
    }

    final prefs = await SharedPreferences.getInstance();

    // Query checkDoctorHome API directly as the true authority on the doctor's institute
    try {
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userId = prefs.getString(AppConstants.prefUserId) ?? '';

      if (userId.isNotEmpty) {
        final resp = await apiClient.post(
          ApiEndpoints.checkDoctorHome,
          data: {'user_id': userId, 'doctor_id': userId, 'id': userId},
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (resp.statusCode == 200 && resp.data != null) {
          var rawData = resp.data;
          if (rawData is String) {
            try {
              rawData = jsonDecode(rawData);
            } catch (_) {}
          }
          if (rawData is Map<String, dynamic>) {
            final res = CheckDoctorHomeResponse.fromJson(rawData);
            final fetchedId = res.data?.instituteId.trim() ?? '';
            if (fetchedId.isNotEmpty && fetchedId != 'null' && fetchedId != '0') {
              instituteId.value = fetchedId;
              await prefs.setString('institute_id', fetchedId);
              debugPrint('DischargeRequestController: resolved institute_id from checkDoctorHome: $fetchedId');
              return fetchedId;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('DischargeRequestController: Error resolving instituteId from checkDoctorHome: $e');
    }

    // Fallback: Check SharedPreferences
    final instId = (prefs.getString('institute_id') ?? '').trim();
    if (instId.isNotEmpty && instId != 'null' && instId != '0') {
      instituteId.value = instId;
      return instId;
    }

    return '';
  }

  /// Fetches discharge requested patients list from web/IPDPatients/ipd_patients_discharge_request_list
  Future<void> loadDischargeRequests() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final targetInstId = await _resolveInstituteId();
      if (targetInstId.isEmpty) {
        debugPrint('loadDischargeRequests: Institute ID could not be determined.');
        allPatients.clear();
        filteredPatients.clear();
        AppSnackbars.showWarning('warning'.tr, 'institute_id_required'.tr);
        return;
      }

      debugPrint('DischargeRequestController: Requesting discharge requests for institute_id: $targetInstId');

      final response = await apiClient.post(
        ApiEndpoints.getDischargeRequestedPatients,
        data: {
          'institute_id': targetInstId,
        },
        options: dio.Options(
          contentType: dio.Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': token,
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
          final res = DischargeRequestResponse.fromJson(rawData);
          allPatients.assignAll(res.data ?? []);
          filterPatients(searchController.text);
        } else {
          allPatients.clear();
          filteredPatients.clear();
        }
      } else {
        AppSnackbars.showError('error'.tr, 'failed_to_load_discharge_requests'.tr);
      }
    } catch (e) {
      debugPrint('loadDischargeRequests error: $e');
      AppSnackbars.showError('error'.tr, 'failed_to_load_discharge_requests'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters patients by name, MHC ID, or mobile number
  void filterPatients(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      filteredPatients.assignAll(allPatients);
    } else {
      filteredPatients.assignAll(
        allPatients.where((item) {
          final name = (item.patientName ?? '').toLowerCase();
          final mhcId = (item.mhcId ?? '').toLowerCase();
          final ipdId = (item.ipdId ?? '').toLowerCase();
          final mobile = (item.mobileNo ?? '').toLowerCase();
          return name.contains(trimmed) ||
              mhcId.contains(trimmed) ||
              ipdId.contains(trimmed) ||
              mobile.contains(trimmed);
        }).toList(),
      );
    }
  }

  /// Prepares and resets state for discharge dialog
  void prepareDischargeDialog(DischargeRequestPatientItem item) {
    pharmacyBillStatus.value = 'paid';
    pharmacyDueController.text = '';

    labBillStatus.value = 'paid';
    labDueController.text = '';

    otherBillStatus.value = 'paid';
    otherDueController.text = '';

    activeDischargePath.value = '';
    fetchDischargeSummary(item.admitId ?? '');
  }

  /// Fetches discharge summary details to check if discharge summary PDF was uploaded
  Future<void> fetchDischargeSummary(String admitId) async {
    if (admitId.isEmpty) return;
    try {
      isLoadingDischargeSummary.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final request = GetDischargeDataRequest(admitId: admitId);
      final response = await apiClient.post(
        ApiEndpoints.getDischargeData,
        data: request.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }

        if (rawData is Map<String, dynamic>) {
          final res = GetDischargeDataResponse.fromJson(rawData);
          if (res.status == 'success' && res.data != null) {
            activeDischargePath.value = res.data!.dischargePath.trim();
          }
        }
      }
    } catch (e) {
      debugPrint('fetchDischargeSummary error: $e');
    } finally {
      isLoadingDischargeSummary.value = false;
    }
  }

  /// Submits final discharge leader clearance to api/v2/User/final_discharge_leader
  Future<void> submitFinalDischarge(DischargeRequestPatientItem item) async {
    final admitId = (item.admitId ?? '').trim();
    if (admitId.isEmpty) {
      AppSnackbars.showWarning('warning'.tr, 'admit_id_empty_warning'.tr);
      return;
    }

    try {
      isSubmittingDischarge.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userType = prefs.getString(AppConstants.prefLoginType) ?? 'Leader';
      final userId = prefs.getString(AppConstants.prefUserId) ?? '';

      final isPharmPaid = pharmacyBillStatus.value == 'paid';
      final pharmPaidStatus = isPharmPaid ? 1 : 0;
      final pharmDue = isPharmPaid ? '0' : pharmacyDueController.text.trim();

      final isLabPaid = labBillStatus.value == 'paid';
      final labPaidStatus = isLabPaid ? 1 : 0;
      final labDue = isLabPaid ? '0' : labDueController.text.trim();

      final isOtherPaid = otherBillStatus.value == 'paid';
      final otherPaidStatus = isOtherPaid ? 1 : 0;
      final otherDue = isOtherPaid ? '0' : otherDueController.text.trim();

      final request = FinalDischargeLeaderRequest(
        admitId: admitId,
        pharmacyBillPaidStatus: pharmPaidStatus,
        pharmacyBillDue: pharmDue.isEmpty ? '0' : pharmDue,
        labBillPaidStatus: labPaidStatus,
        labBillDue: labDue.isEmpty ? '0' : labDue,
        otherBillPaidStatus: otherPaidStatus,
        otherBillDue: otherDue.isEmpty ? '0' : otherDue,
        dischargeBy: userType,
        dischargeById: userId,
      );

      final formData = dio.FormData.fromMap(request.toMap());

      final response = await apiClient.post(
        ApiEndpoints.finalDischargeLeader,
        data: formData,
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

        final status = (rawData is Map) ? rawData['status']?.toString() : null;
        final msg = (rawData is Map) ? rawData['msg']?.toString() : null;

        if (status == 'success') {
          Get.back(); // Close dialog
          AppSnackbars.showSuccess(
            'success'.tr,
            msg ?? 'discharge_request_completed'.tr,
          );
          loadDischargeRequests();
        } else {
          AppSnackbars.showError('error'.tr, msg ?? 'discharge_request_failed'.tr);
        }
      } else {
        AppSnackbars.showError('error'.tr, 'discharge_request_failed'.tr);
      }
    } catch (e) {
      debugPrint('submitFinalDischarge error: $e');
      AppSnackbars.showError('error'.tr, 'discharge_request_failed'.tr);
    } finally {
      isSubmittingDischarge.value = false;
    }
  }
}
