import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/constants/app_constants.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Ensure overlays are active and styled when Splash Screen is initialized
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
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final prefs = StorageService.to.prefs;
    final isLoggedIn = prefs.getBool(AppConstants.prefIsLogin) ?? false;
    final loginType = prefs.getString(AppConstants.prefLoginType) ?? '';

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        final lower = loginType.toLowerCase();
        if (lower == 'patient') {
          Get.offNamed('/patient-dashboard');
        } else if (lower == 'leader' || lower == 'reception') {
          Get.offNamed('/leader-dashboard');
        } else {
          Get.offNamed('/doctor-dashboard');
        }
      } else {
        Get.offNamed('/login');
      }
    });
  }
}
