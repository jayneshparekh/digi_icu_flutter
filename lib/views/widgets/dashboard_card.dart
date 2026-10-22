import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;
  final String? badgeText;

  const DashboardCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.iconColor = AppColors.teal,
    this.backgroundColor = AppColors.white,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.medicalGray, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: iconPath.startsWith('http')
                          ? Image.network(
                              iconPath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                color: AppColors.medicalGray,
                              ),
                            )
                          : iconPath.endsWith('.svg')
                          ? SvgPicture.asset(
                              iconPath,
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                              fit: BoxFit.contain,
                            )
                          : Image.asset(iconPath, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (badgeText != null && badgeText!.isNotEmpty)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
