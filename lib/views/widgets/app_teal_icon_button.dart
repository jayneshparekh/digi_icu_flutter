import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A square tappable button with an [AppColors.primary] background and a
/// white SVG icon.
class AppTealIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double size;
  final double iconPadding;
  final double borderRadius;

  const AppTealIconButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.size = 40,
    this.iconPadding = 8,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(iconPadding),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
