import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GraphLegendBadge extends StatelessWidget {
  final Color color;
  final String label;

  const GraphLegendBadge({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
