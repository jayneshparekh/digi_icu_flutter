import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
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
