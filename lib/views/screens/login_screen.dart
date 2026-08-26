import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';

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
                          TextField(
                            onChanged: (val) =>
                                controller.username.value = val,
                            decoration: InputDecoration(
                              labelText: 'mobile_login_id'.tr,
                              labelStyle: TextStyle(
                                color: AppColors.coolGray,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.medicalGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.teal,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            onChanged: (val) =>
                                controller.password.value = val,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'password'.tr,
                              labelStyle: TextStyle(
                                color: AppColors.coolGray,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.medicalGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.teal,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
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

                            return SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: (isValid && !isLoading)
                                    ? controller.login
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  disabledBackgroundColor:
                                      AppColors.blue
                                          .withValues(alpha: 0.5),
                                  foregroundColor: AppColors.white,
                                  disabledForegroundColor: AppColors.white.withValues(alpha: 0.7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: AppColors.white,
                                      )
                                    : Text(
                                        'login_btn'.tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
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


