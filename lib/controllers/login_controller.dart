import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/choose_patient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/constants/app_constants.dart';
import '../models/response/users/login_response.dart';
import '../services/api/api_client.dart';
import '../services/storage_service.dart';

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
    if (!isFormValid) {
      _showErrorSnackbar('please_enter_credentials'.tr);
      return;
    }

    final input = username.value.trim();
    final pass = password.value.trim();

    isLoading.value = true;

    try {
      final response = await apiClient.post(
        ApiEndpoints.signin,
        data: {'email_id': input, 'password': pass, 'token': ''},
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginRes = LoginResponse.fromJson(response.data);
        if (loginRes.status == 'success') {
          // Tell the OS autofill service to prompt to save the credentials
          TextInput.finishAutofillContext(shouldSave: true);

          final storage = StorageService.to;
          await storage.setString(
            AppConstants.prefAuthorizationToken,
            loginRes.authToken,
          );

          if (loginRes.data != null) {
            await _storeUserDataAndNavigate(loginRes.data!);
          } else if (loginRes.patientList.isNotEmpty) {
            if (loginRes.patientList.length == 1) {
              await _storeUserDataAndNavigate(loginRes.patientList[0]);
            } else {
              if (Get.context != null) {
                ChoosePatientDialog.show(
                  context: Get.context!,
                  patients: loginRes.patientList,
                  onSelect: (selectedPatient) async {
                    await _storeUserDataAndNavigate(selectedPatient);
                  },
                );
              }
            }
          } else {
            _showErrorSnackbar(
              loginRes.msg.isNotEmpty ? loginRes.msg : 'login_failed'.tr,
            );
          }
        } else {
          _showErrorSnackbar(
            loginRes.msg.isNotEmpty ? loginRes.msg : 'login_failed'.tr,
          );
        }
      } else {
        _showErrorSnackbar('request_failed'.tr);
      }
    } catch (e, stacktrace) {
      debugPrint('Login request failed: $e');
      debugPrintStack(stackTrace: stacktrace);
      _showErrorSnackbar(ApiClient.errorMessageKey(e).tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _storeUserDataAndNavigate(LoginDataRes data) async {
    final storage = StorageService.to;
    await storage.setBool(AppConstants.prefIsLogin, true);
    await storage.setString(AppConstants.prefUserId, data.id);
    await storage.setString(AppConstants.prefLoginType, data.userType);
    final fullName = '${data.firstName} ${data.surname}'.trim();
    await storage.setString(
      AppConstants.prefUserName,
      fullName.isNotEmpty ? fullName : data.firstName,
    );
    await storage.setString(AppConstants.prefUserMhcId, data.mhcId);
    await storage.setString(AppConstants.prefUserGender, data.gender);
    await storage.setString(AppConstants.prefUserAge, data.age);
    await storage.setString(AppConstants.prefUserMobileNumber, data.mobileNo);
    await storage.setString(AppConstants.prefUserEmail, data.mhcEmail);
    await storage.setString(AppConstants.prefScreeningId, data.screeningId);
    await storage.setString(AppConstants.doctorRegSec2Pending, data.section2);
    await storage.setString(AppConstants.doctorRegSec3Pending, data.section3);
    await storage.setString(AppConstants.prefInstituteName, data.instituteName);

    _redirectToDashboard(data.userType, data);
  }

  void _redirectToDashboard(String userType, LoginDataRes data) {
    final lowerUserType = userType.toLowerCase();
    if (lowerUserType == 'patient') {
      Get.offAllNamed(
        '/patient-dashboard',
        arguments: {
          'patientId': data.id,
          'patient_id': data.id,
          'userName': '${data.firstName} ${data.surname}'.trim(),
          'userAge': data.age,
          'userGender': data.gender,
          'screeningId': data.screeningId,
          'type': 'Self',
        },
      );
    } else if (lowerUserType == 'leader' || lowerUserType == 'reception') {
      Get.offAllNamed('/leader-dashboard');
    } else {
      Get.offAllNamed('/doctor-dashboard');
    }
  }

  void _showErrorSnackbar(String message) {
    AppSnackbars.showError('error'.tr, message);
  }
}
