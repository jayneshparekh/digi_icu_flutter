class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://www.mhclinic.net/MHC/api/';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Preference Keys
  static const String prefIsLogin = 'is_login';
  static const String prefAuthorizationToken = 'authorization_token';
  static const String prefUserId = 'user_id';
  static const String prefLoginType = 'login_type';
  static const String prefUserName = 'user_name';
  static const String prefUserMhcId = 'user_mhc_id';
  static const String prefUserGender = 'gender';
  static const String prefUserAge = 'age';
  static const String prefUserMobileNumber = 'mobile_no';
  static const String prefUserEmail = 'mhc_email';
  static const String prefScreeningId = 'screening_id';
  static const String doctorRegSec2Pending = 'section_2';
  static const String doctorRegSec3Pending = 'section_3';
}
