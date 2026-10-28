import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

/// Singleton service managing local key-value persistence.
/// Wraps [SharedPreferences] to eliminate redundant asynchronous disk I/O lookups.
class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late final SharedPreferences _prefs;

  /// Direct access to underlying [SharedPreferences] instance.
  SharedPreferences get prefs => _prefs;

  /// Initializes the [SharedPreferences] singleton once at application startup.
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Generic Typed Getters & Setters
  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clear() {
    return _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // App-Specific Convenience Accessors
  String get token => getString(AppConstants.prefAuthorizationToken);
  String get userId => getString(AppConstants.prefUserId);
  String get userName => getString(AppConstants.prefUserName);
  String get userType => getString(AppConstants.prefLoginType);
  String get patientId => getString(AppConstants.prefSelectedPatientId);
  String get doctorId => getString(AppConstants.prefSelectedDoctorId);
  String get leaderId => getString(AppConstants.prefSelectedLeaderId);
}
