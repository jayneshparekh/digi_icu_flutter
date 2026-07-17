import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/response/doctors/check_doctor_home_response.dart';
import '../services/api/api_client.dart';

class DoctorDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString doctorName = ''.obs;
  final RxString userType = ''.obs;

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

  @override
  void onInit() {
    super.onInit();
    // Ensure overlays are active and styled when Doctor Dashboard is initialized
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _loadDoctorName();
    checkDoctorHome();
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
    accountStatus.value = prefs.getString('account_status') ?? '';
    instituteDoctor.value = prefs.getString('institute_doctor') ?? '';
    instituteId.value = prefs.getString('institute_id') ?? '';
  }

  /// Calls check_home API to retrieve account verification status, institute info, etc.
  Future<void> checkDoctorHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      if (doctorId.isEmpty) return;

      final response = await apiClient.post(
        ApiEndpoints.checkDoctorHome,
        data: {'doctor_id': doctorId, 'user_id': doctorId, 'id': doctorId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = CheckDoctorHomeResponse.fromJson(response.data);
        if (res.status == 'success' && res.data != null) {
          accountStatus.value = res.data!.accountStatus;
          instituteDoctor.value = res.data!.instituteDoctor;
          instituteId.value = res.data!.instituteId;

          // Save variables to SharedPreferences
          await prefs.setString('account_status', res.data!.accountStatus);
          await prefs.setString('institute_doctor', res.data!.instituteDoctor);
          await prefs.setString('institute_id', res.data!.instituteId);
        }
      }
    } catch (e) {
      // Fail silently
      Get.printError(info: 'checkDoctorHome exception: $e');
    }
  }

  /// Checks if orientation is already set. If yes, applies it and returns true.
  /// Otherwise, sets default based on device type and returns false (requires dialog).
  Future<bool> checkAndApplyOrientation(double shortestSide) async {
    final prefs = await SharedPreferences.getInstance();
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
      final prefs = await SharedPreferences.getInstance();
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
    final prefs = await SharedPreferences.getInstance();
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
    final prefs = await SharedPreferences.getInstance();
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



