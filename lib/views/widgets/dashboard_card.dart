import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.iconColor = AppColors.primary,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: backgroundColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
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
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : iconPath.endsWith('.svg')
                        ? SvgPicture.asset(
                            iconPath,
                            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            iconPath,
                            fit: BoxFit.contain,
                          ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


