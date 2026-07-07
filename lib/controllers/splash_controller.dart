import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Ensure overlays are active and styled when Splash Screen is initialized
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF00897B),
      statusBarIconBrightness: Brightness.light,
    ));
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.prefIsLogin) ?? false;

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Get.offNamed('/doctor-dashboard');
      } else {
        Get.offNamed('/login');
      }
    });
  }
}
