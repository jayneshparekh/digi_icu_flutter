import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A standardized section header used in clinical form screens.
/// Renders a grey [subtitle], a bold primary-colored [title], and a short
/// teal underline bar below the title.
class AppFormSectionHeader extends StatelessWidget {
  final String subtitle;
  final String title;

  const AppFormSectionHeader({
    super.key,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.medicalGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 100,
          height: 2,
          color: AppColors.teal,
        ),
      ],
    );
  }
}
