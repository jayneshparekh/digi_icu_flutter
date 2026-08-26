import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/response/users/login_response.dart';
import '../services/api/api_client.dart';

class LoginController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final RxString username = ''.obs;
  final RxString password = ''.obs;
  final RxBool isLoading = false.obs;

  bool get isFormValid =>
      username.value.trim().isNotEmpty && password.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Ensure overlays are active and styled when Login Screen is initialized
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
  }

  Future<void> login() async {
    if (!isFormValid) return;

    final input = username.value.trim();
    final pass = password.value.trim();

    // Validation
    final hasDigits = RegExp(r'[0-9]').hasMatch(input);
    if (hasDigits) {
      // Must be exactly 10 digits and only numbers
      final isOnlyDigits = RegExp(r'^[0-9]+$').hasMatch(input);
      if (!isOnlyDigits || input.length != 10) {
        _showErrorSnackbar('Wrong Credentials');
        return;
      }
    } else {
      // Must contain ".doc"
      if (!input.contains('.doc')) {
        _showErrorSnackbar('Wrong Credentials');
        return;
      }
    }

    isLoading.value = true;

    try {
      final response = await apiClient.post(
        ApiEndpoints.signin,
        data: {
          'email_id': input,
          'password': pass,
          'token': '',
          // Empty FCM token as fallback
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginRes = LoginResponse.fromJson(response.data);
        if (loginRes.status == 'success') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            AppConstants.prefAuthorizationToken,
            loginRes.authToken,
          );
          await prefs.setBool(AppConstants.prefIsLogin, true);

          if (loginRes.data != null) {
            final data = loginRes.data!;
            await prefs.setString(AppConstants.prefUserId, data.id);
            await prefs.setString(AppConstants.prefLoginType, data.userType);
            await prefs.setString(
              AppConstants.prefUserName,
              '${data.firstName} ${data.surname}',
            );
            await prefs.setString(AppConstants.prefUserMhcId, data.mhcId);
            await prefs.setString(AppConstants.prefUserGender, data.gender);
            await prefs.setString(AppConstants.prefUserAge, data.age);
            await prefs.setString(
              AppConstants.prefUserMobileNumber,
              data.mobileNo,
            );
            await prefs.setString(AppConstants.prefUserEmail, data.mhcEmail);
            await prefs.setString(
              AppConstants.prefScreeningId,
              data.screeningId,
            );
            await prefs.setString(
              AppConstants.doctorRegSec2Pending,
              data.section2,
            );
            await prefs.setString(
              AppConstants.doctorRegSec3Pending,
              data.section3,
            );
          }

          Get.offAllNamed('/doctor-dashboard');
        } else {
          _showErrorSnackbar(
            loginRes.msg.isNotEmpty ? loginRes.msg : 'Login Failed',
          );
        }
      } else {
        _showErrorSnackbar('Something went wrong: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      debugPrint('Login Error Details: $e');
      debugPrint('Stacktrace: $stacktrace');
      _showErrorSnackbar('Connection error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.error,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
    );
  }
}



