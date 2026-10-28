import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/response/doctors/check_doctor_home_response.dart';
import '../services/api/api_client.dart';
import '../services/storage_service.dart';
import '../views/widgets/app_dialog.dart';

class DoctorDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  late final SharedPreferences _prefs;

  final RxString doctorName = ''.obs;
  final RxString userType = ''.obs;

  /// TextEditingController for Voice Input / Notes widget on Doctor Dashboard
  final noteTextController = TextEditingController();

  // Selected layout orientation selection ('portrait' or 'landscape')
  final RxString selectedOrientation = 'portrait'.obs;

  // Checkbox 'Set this orientation as default' is checked by default
  final RxBool setAsDefault = true.obs;

  // Track if orientation dialog is currently shown to prevent duplicates
  final RxBool isDialogShown = false.obs;

  // Doctor status and profile states loaded from check_home API
  final RxString accountStatus = ''.obs;
  final RxString instituteDoctor = ''.obs;
  final RxString instituteId = ''.obs;

  // New badge status for Admit Request (id 27)
  final RxBool hasNewAdmitRequests = false.obs;

  // New badge status for Discharge Request (id 26)
  final RxBool hasNewDischargeRequests = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.isRegistered<SharedPreferences>()
        ? Get.find<SharedPreferences>()
        : Get.find<StorageService>().prefs;
    // Ensure overlays are active and styled when Doctor Dashboard is initialized
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
    _loadDoctorName();
    checkDoctorHome();
  }

  @override
  void onClose() {
    noteTextController.dispose();
    super.onClose();
  }

  Future<void> _loadDoctorName() async {
    final prefs = _prefs;
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
    accountStatus.value = prefs.getString('account_status') ?? '';
    instituteDoctor.value = prefs.getString('institute_doctor') ?? '';
    instituteId.value = prefs.getString('institute_id') ?? '';
  }

  /// Calls check_home API to retrieve account verification status, institute info, etc.
  Future<void> checkDoctorHome() async {
    try {
      final prefs = _prefs;
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (doctorId.isEmpty) {
        return;
      }

      final response = await apiClient.post(
        ApiEndpoints.checkDoctorHome,
        data: {'doctor_id': doctorId, 'user_id': doctorId, 'id': doctorId},
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
          final res = CheckDoctorHomeResponse.fromJson(rawData);
          if (res.status == 'success' && res.data != null) {
            accountStatus.value = res.data!.accountStatus;
            instituteDoctor.value = res.data!.instituteDoctor;

            final tempInstId = res.data!.instituteId.trim();
            final validInstId = (tempInstId.isEmpty || tempInstId == 'null' || tempInstId == '0')
                ? ''
                : tempInstId;
            instituteId.value = validInstId;

            // Save variables to SharedPreferences
            await prefs.setString('account_status', res.data!.accountStatus);
            await prefs.setString('institute_doctor', res.data!.instituteDoctor);
            await prefs.setString('institute_id', validInstId);
            debugPrint('checkDoctorHome: successfully set institute_id to $validInstId');
          }
        }
      }
    } catch (e) {
      // Fail silently
      Get.printError(info: 'checkDoctorHome exception: $e');
    } finally {
      // Always call badge fetchers whether institute_id was returned or already present
      fetchAdmitRequestsBadge();
      fetchDischargeRequestsBadge();
    }
  }

  /// Fetches new admit requests badge status
  Future<void> fetchAdmitRequestsBadge() async {
    try {
      final prefs = _prefs;
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentInstId = instituteId.value.isNotEmpty
          ? instituteId.value
          : (prefs.getString('institute_id') ?? '');

      if (doctorId.isEmpty) {
        return;
      }

      final formDataMap = <String, dynamic>{
        'status': 'Admit Requested',
        'leader_id': doctorId,
      };
      if (currentInstId.isNotEmpty) {
        formDataMap['institute_id'] = currentInstId;
      }

      final resp = await apiClient.post(
        ApiEndpoints.getAdmitRequestsByStatus,
        data: dio.FormData.fromMap(formDataMap),
        options: dio.Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        var rawData = resp.data;
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

  /// Handles Admit Request dashboard card click (marks notification read & navigates)
  Future<void> onAdmitRequestClick(BuildContext context) async {
    if (accountStatus.value == '2') {
      _showPendingRegistrationDialog(context);
      return;
    }

    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentInstId = instituteId.value.isNotEmpty
          ? instituteId.value
          : (prefs.getString('institute_id') ?? '');

      if (currentInstId.isNotEmpty) {
        final formData = dio.FormData.fromMap({'institute_id': currentInstId});
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
      arguments: {'institute_id': instituteId.value},
    );
  }

  /// Helper to get or resolve current institute ID
  Future<String> _resolveInstituteId() async {
    String currentInstId = instituteId.value.trim();
    if (currentInstId.isNotEmpty && currentInstId != 'null' && currentInstId != '0') {
      return currentInstId;
    }

    // Refresh from checkDoctorHome as the single source of truth for doctor's active institute
    await checkDoctorHome();
    currentInstId = instituteId.value.trim();
    if (currentInstId.isNotEmpty && currentInstId != 'null' && currentInstId != '0') {
      return currentInstId;
    }

    final prefs = _prefs;
    currentInstId = (prefs.getString('institute_id') ?? '').trim();
    if (currentInstId.isNotEmpty && currentInstId != 'null' && currentInstId != '0') {
      instituteId.value = currentInstId;
      return currentInstId;
    }

    return '';
  }

  /// Fetches new discharge requests badge status
  Future<void> fetchDischargeRequestsBadge() async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentInstId = await _resolveInstituteId();

      if (currentInstId.isEmpty) {
        return;
      }

      final resp = await apiClient.post(
        ApiEndpoints.getDischargeRequestedPatients,
        data: {'institute_id': currentInstId},
        options: dio.Options(
          contentType: dio.Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        var rawData = resp.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          final hasNew = rawData['has_new'];
          hasNewDischargeRequests.value =
              hasNew == true || hasNew == 1 || hasNew?.toString() == 'true' || hasNew?.toString() == '1';
        }
      }
    } catch (e) {
      debugPrint('fetchDischargeRequestsBadge exception: $e');
    }
  }

  /// Handles Discharge Request dashboard card click (marks notification read & navigates)
  Future<void> onDischargeRequestClick(BuildContext context) async {
    if (accountStatus.value == '2') {
      _showPendingRegistrationDialog(context);
      return;
    }

    final currentInstId = await _resolveInstituteId();

    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (currentInstId.isNotEmpty) {
        final formData = dio.FormData.fromMap({'institute_id': currentInstId});
        await apiClient.post(
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
      arguments: {'institute_id': currentInstId.isNotEmpty ? currentInstId : instituteId.value},
    );
  }

  void _showPendingRegistrationDialog(BuildContext context) {
    AppDialog.show(
      title: 'warning'.tr,
      confirmLabel: 'okay'.tr,
      cancelLabel: 'cancel'.tr,
      onConfirm: () => Get.back(),
      onCancel: () => Get.back(),
      body: Text(
        'registration_pending_msg'.tr,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
      ),
    );
  }

  /// Checks if orientation is already set. If yes, applies it and returns true.
  /// Otherwise, sets default based on device type and returns false (requires dialog).
  Future<bool> checkAndApplyOrientation(double shortestSide) async {
    final prefs = _prefs;
    final savedOrientation = prefs.getString(AppConstants.prefUserOrientation);

    if (savedOrientation != null) {
      _applyOrientation(savedOrientation);
      return true; // Already configured
    } else {
      // Default: Portrait for mobile, Landscape for tablet (shortestSide >= 600 dp)
      final isTablet = shortestSide >= 600;
      selectedOrientation.value = isTablet ? 'landscape' : 'portrait';
      return false; // Requires configuration dialog
    }
  }

  /// Saves the selected configuration (if default is checked) and applies the orientations.
  Future<void> saveAndApplySelectedOrientation() async {
    if (setAsDefault.value) {
      final prefs = _prefs;
      await prefs.setString(
        AppConstants.prefUserOrientation,
        selectedOrientation.value,
      );
    }
    _applyOrientation(selectedOrientation.value);
  }

  Future<void> toggleOrientation() async {
    if (selectedOrientation.value == 'portrait') {
      selectedOrientation.value = 'landscape';
    } else {
      selectedOrientation.value = 'portrait';
    }
    final prefs = _prefs;
    await prefs.setString(
      AppConstants.prefUserOrientation,
      selectedOrientation.value,
    );
    _applyOrientation(selectedOrientation.value);
  }

  void _applyOrientation(String orientation) {
    if (orientation == 'landscape') {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  Future<void> logout() async {
    final prefs = _prefs;
    // Revert orientation settings to system settings on logout
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await prefs.clear();
    Get.offAllNamed('/login');
  }
}
