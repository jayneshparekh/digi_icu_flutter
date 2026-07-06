import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class DoctorDashboardController extends GetxController {
  final RxString doctorName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }
}
