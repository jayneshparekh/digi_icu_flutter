import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LabParameterTableRow extends StatelessWidget {
  final String label;
  final List<String> values;
  final bool isHeader;
  final double labelWidth;
  final double cellWidth;

  const LabParameterTableRow({
    super.key,
    required this.label,
    required this.values,
    this.isHeader = false,
    this.labelWidth = 110.0,
    this.cellWidth = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isHeader ? AppColors.lightGray : AppColors.white;
    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: AppColors.navy,
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.medicalGray, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed Left Label Cell
          Container(
            width: labelWidth,
            height: 38,
            color: bg,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            alignment: Alignment.center,
            child: Text(
              label,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 0.5,
            height: 38,
            color: AppColors.medicalGray,
          ),
          // Value Cells (Horizontal list)
          ...values.map(
            (val) => Container(
              width: cellWidth,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.medicalGray, width: 0.5),
                ),
              ),
              child: Text(
                val.isNotEmpty ? val : '-',
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
