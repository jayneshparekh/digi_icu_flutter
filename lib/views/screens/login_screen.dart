import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../views/widgets/app_labeled_text_field.dart';
import '../../views/widgets/app_primary_button.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    // Center Logo Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.asset(
                        'assets/images/digi_icu_critical_care.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Input Fields Form & Login Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppLabeledTextField(
                            onChanged: (val) => controller.username.value = val,
                            label: 'mobile_login_id'.tr,
                            hint: 'mobile_login_id'.tr,
                          ),
                          const SizedBox(height: 12),
                          AppLabeledTextField(
                            onChanged: (val) => controller.password.value = val,
                            obscureText: true,
                            label: 'password'.tr,
                            hint: 'password'.tr,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Forgot password logic placeholder
                            },
                            child: Text(
                              'forgot_password'.tr,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Login Button
                          Obx(() {
                            final isValid = controller.isFormValid;
                            final isLoading = controller.isLoading.value;

                            return AppPrimaryButton(
                              label: 'login_btn'.tr,
                              onPressed: isValid ? controller.login : null,
                              isLoading: isLoading,
                              backgroundColor: AppColors.blue,
                              labelStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              height: 54,
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


