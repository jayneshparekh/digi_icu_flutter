import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class DoctorDashboardController extends GetxController {
  final RxString doctorName = ''.obs;

  // Selected layout orientation selection ('portrait' or 'landscape')
  final RxString selectedOrientation = 'portrait'.obs;
  // Checkbox 'Set this orientation as default' is checked by default
  final RxBool setAsDefault = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure overlays are active and styled when Doctor Dashboard is initialized
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF00897B),
      statusBarIconBrightness: Brightness.light,
    ));
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
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
      await prefs.setString(AppConstants.prefUserOrientation, selectedOrientation.value);
    }
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
