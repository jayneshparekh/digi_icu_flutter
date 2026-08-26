import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A full-screen semi-transparent overlay displayed during loading operations.
/// Wrap around the body stack — it will sit on top of the content only
/// when [isLoading] is true.
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const AppLoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: AppColors.pureBlack.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
        ),
      ),
    );
  }
}
