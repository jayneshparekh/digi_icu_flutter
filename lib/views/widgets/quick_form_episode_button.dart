import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class QuickFormEpisodeButton extends StatelessWidget {
  final String label;
  final String imageName; // e.g. 'm_breathing', 'm_chest_pain'
  final bool isSelected;
  final VoidCallback onTap;

  const QuickFormEpisodeButton({
    super.key,
    required this.label,
    required this.imageName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.error.withValues(alpha: 0.1) : AppColors.lightGray,
              border: Border.all(
                color: isSelected ? AppColors.error : AppColors.medicalGray,
                width: isSelected ? 2.5 : 1.0,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/$imageName.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.favorite,
                  color: isSelected ? AppColors.error : AppColors.coolGray,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 76,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.error : AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
