import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A standardized base dialog layout.
/// Features a uniform header with title and circular close button,
/// a dynamic body, and an optional cancel/confirm footer.
class AppDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isConfirmLoading;
  final bool showCloseButton;

  const AppDialog({
    super.key,
    required this.title,
    required this.body,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isConfirmLoading = false,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Close Button Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (showCloseButton)
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Dynamic Body
            Flexible(
              child: SingleChildScrollView(
                child: body,
              ),
            ),
            // Optional Cancel/Confirm Footer
            if (confirmLabel != null || cancelLabel != null) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelLabel != null)
                    TextButton(
                      onPressed: onCancel ?? () => Get.back(),
                      child: Text(
                        cancelLabel!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (cancelLabel != null && confirmLabel != null)
                    const SizedBox(width: 16),
                  if (confirmLabel != null)
                    SizedBox(
                      width: 110,
                      child: AppPrimaryButton(
                        label: confirmLabel!,
                        onPressed: onConfirm,
                        isLoading: isConfirmLoading,
                        height: 38,
                        borderRadius: 6,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper static method to quickly show this standard dialog
  static Future<T?> show<T>({
    required String title,
    required Widget body,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isConfirmLoading = false,
    bool showCloseButton = true,
  }) {
    return Get.dialog<T>(
      AppDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isConfirmLoading: isConfirmLoading,
        showCloseButton: showCloseButton,
      ),
    );
  }
}
