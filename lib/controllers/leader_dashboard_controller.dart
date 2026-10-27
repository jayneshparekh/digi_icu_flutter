import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_endpoints.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../services/api/api_client.dart';

class LeaderDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString leaderId = ''.obs;
  final RxString leaderName = ''.obs;
  final RxString userType = 'Leader'.obs;
  final RxString mhcId = ''.obs;
  final RxString instituteName = ''.obs;

  final RxString ecgPkgPayment = ''.obs;
  final RxString instLeader = ''.obs;
  final RxString isDefaultDoctorLeader = ''.obs;
  final RxString defaultInstituteId = ''.obs;
  final RxString instituteShortName = ''.obs;

  // New badge statuses
  final RxBool hasNewAdmitRequests = false.obs;
  final RxBool hasNewDischargeRequests = false.obs;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.teal,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _loadLeaderInfo();
  }

  Future<void> _loadLeaderInfo() async {
    final prefs = await SharedPreferences.getInstance();
    leaderId.value = prefs.getString(AppConstants.prefUserId) ?? '';
    leaderName.value = prefs.getString(AppConstants.prefUserName) ?? 'Leader';
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Leader';
    mhcId.value = prefs.getString(AppConstants.prefUserMhcId) ?? '';
    instituteName.value = prefs.getString(AppConstants.prefInstituteName) ?? '';

    await checkLeaderHome();
  }

  Future<void> checkLeaderHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = leaderId.value.isNotEmpty
          ? leaderId.value
          : (prefs.getString(AppConstants.prefUserId) ?? '');
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (currentUserId.isEmpty) return;

      final response = await apiClient.post(
        ApiEndpoints.checkLeaderHome,
        data: {'user_id': currentUserId, 'id': currentUserId},
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
          ecgPkgPayment.value = rawData['ecg_package_payment']?.toString() ?? '';
          instLeader.value = rawData['institute_leader']?.toString() ?? '';
          isDefaultDoctorLeader.value =
              rawData['is_default_doctor_leader']?.toString() ?? '';
          defaultInstituteId.value =
              rawData['default_institute_id']?.toString() ?? '';

          final shortName = rawData['short_name']?.toString() ?? '';
          if (shortName.isNotEmpty) {
            instituteShortName.value = shortName;
          }
        }
      }
    } catch (e) {
      Get.printError(info: 'checkLeaderHome exception: $e');
    } finally {
      fetchDischargeRequestsBadge();
      fetchAdmitRequestsBadge();
    }
  }

  Future<void> fetchDischargeRequestsBadge() async {
    try {
      if (defaultInstituteId.value.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final formData = dio.FormData.fromMap({
        'institute_id': defaultInstituteId.value,
        'clearance_status': '0',
      });

      final response = await apiClient.post(
        ApiEndpoints.getDischargeRequestedPatients,
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
        if (rawData is Map<String, dynamic>) {
          final hasNew = rawData['has_new'];
          hasNewDischargeRequests.value =
              hasNew is bool ? hasNew : (hasNew?.toString() == 'true');
        }
      }
    } catch (e) {
      debugPrint('fetchDischargeRequestsBadge exception: $e');
    }
  }

  Future<void> fetchAdmitRequestsBadge() async {
    try {
      if (defaultInstituteId.value.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentUserId = leaderId.value.isNotEmpty
          ? leaderId.value
          : (prefs.getString(AppConstants.prefUserId) ?? '');

      final formData = dio.FormData.fromMap({
        'status': 'Admit Requested',
        'leader_id': currentUserId,
        'institute_id': defaultInstituteId.value,
      });

      final response = await apiClient.post(
        ApiEndpoints.getAdmitRequestsByStatus,
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
        if (rawData is Map<String, dynamic>) {
          final hasNew = rawData['has_new'];
          hasNewAdmitRequests.value =
              hasNew is bool ? hasNew : (hasNew?.toString() == 'true');
        }
      }
    } catch (e) {
      debugPrint('fetchAdmitRequestsBadge exception: $e');
    }
  }

  void openManagePatients() {
    Get.toNamed(
      '/manage-patients',
      arguments: {
        'isFrom': 'leader',
        'leaderId': leaderId.value,
        'instLeader': instLeader.value,
        'defaultInstId': defaultInstituteId.value,
      },
    );
  }

  void openIpdPatients() {
    Get.toNamed(
      '/ipd-patient-list',
      arguments: {
        'institute_id': defaultInstituteId.value,
      },
    );
  }

  Future<void> openAdmitRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (defaultInstituteId.value.isNotEmpty) {
        final formData = dio.FormData.fromMap({
          'institute_id': defaultInstituteId.value,
        });
        apiClient.post(
          ApiEndpoints.markAdmitPatientRequestNotificationsAsRead,
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': token,
              'Content-Type': 'application/x-www-form-urlencoded',
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error marking admit notifications as read: $e');
    }

    hasNewAdmitRequests.value = false;
    Get.toNamed(
      '/admit-patient-request',
      arguments: {
        'institute_id': defaultInstituteId.value,
      },
    );
  }

  Future<void> openDischargeRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (defaultInstituteId.value.isNotEmpty) {
        final formData = dio.FormData.fromMap({
          'institute_id': defaultInstituteId.value,
        });
        apiClient.post(
          ApiEndpoints.markDischargePatientRequestNotificationsAsRead,
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': token,
              'Content-Type': 'application/x-www-form-urlencoded',
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error marking discharge notifications as read: $e');
    }

    hasNewDischargeRequests.value = false;
    Get.toNamed(
      '/discharge-request',
      arguments: {
        'institute_id': defaultInstituteId.value,
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }
}
