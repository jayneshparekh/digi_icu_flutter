import 'package:digi_icu_flutter/controllers/login_controller.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late LoginController controller;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<ApiClient>(ApiClient());
    controller = LoginController();
  });

  tearDown(() {
    Get.reset();
  });

  test('login form is invalid until both fields contain text', () {
    expect(controller.isFormValid, isFalse);

    controller.username.value = 'doctor@example.com';
    expect(controller.isFormValid, isFalse);

    controller.password.value = 'password';
    expect(controller.isFormValid, isTrue);
  });

  test('login form validation ignores surrounding whitespace', () {
    controller.username.value = '  doctor@example.com  ';
    controller.password.value = '  password  ';

    expect(controller.isFormValid, isTrue);
  });
}
