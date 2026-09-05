import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable prescription row tile component displaying visit number and date in a pill container.
class PrescriptionRowTile extends StatelessWidget {
  final int index;
  final String visitNo;
  final String date;
  final VoidCallback onTap;
  final Color backgroundColor;

  const PrescriptionRowTile({
    super.key,
    required this.index,
    required this.visitNo,
    required this.date,
    required this.onTap,
    this.backgroundColor = AppColors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Index number (e.g. "1.", "10.")
                SizedBox(
                  width: 32,
                  child: Text(
                    '$index.',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Visit number (e.g. "Visit no: 23")
                Expanded(
                  child: Text(
                    visitNo.isNotEmpty ? 'Visit no: $visitNo' : 'Visit',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Date (e.g. "03-09-2026")
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
