import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized SnackBar utility for uniform notification popups.
class AppSnackbars {
  AppSnackbars._();

  /// Displays a success notification
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  /// Displays an error notification
  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      icon: const Icon(Icons.error_outline, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  /// Displays a warning notification
  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warning,
      colorText: AppColors.white,
      icon: const Icon(Icons.warning_amber_outlined, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  /// Displays an information notification
  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      icon: const Icon(Icons.info_outline, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
