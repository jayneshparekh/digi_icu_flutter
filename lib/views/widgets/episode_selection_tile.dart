import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EpisodeSelectionTile extends StatelessWidget {
  final String label;
  final String imageName; // e.g. 'm_breathing', 'm_chest_pain'
  final bool isSelected;
  final VoidCallback onTap;

  const EpisodeSelectionTile({
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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.error.withValues(alpha: 0.12)
                      : AppColors.lightGray,
                  border: Border.all(
                    color: isSelected ? AppColors.error : AppColors.medicalGray,
                    width: isSelected ? 2.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.25),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
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
              if (isSelected)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 86,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.error : AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
