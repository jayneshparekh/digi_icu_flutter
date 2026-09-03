import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A standardized branded Radio button wrapping the Flutter [Radio] widget.
/// Auto-applies [AppColors.teal] as the active color and standard visual density.
/// Designed to be used inside a [RadioGroup] ancestor.
class AppRadio<T> extends StatelessWidget {
  final T value;
  final VisualDensity visualDensity;
  final MaterialTapTargetSize materialTapTargetSize;

  const AppRadio({
    super.key,
    required this.value,
    this.visualDensity = VisualDensity.compact,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: value,
      activeColor: AppColors.teal,
      visualDensity: visualDensity,
      materialTapTargetSize: materialTapTargetSize,
    );
  }
}

/// A standardized branded RadioListTile wrapping the Flutter [RadioListTile] widget.
/// Auto-applies [AppColors.teal] as the active color.
/// Designed to be used inside a [RadioGroup] ancestor.
class AppRadioListTile<T> extends StatelessWidget {
  final T value;
  final Widget? title;
  final Widget? subtitle;
  final EdgeInsetsGeometry contentPadding;

  const AppRadioListTile({
    super.key,
    required this.value,
    this.title,
    this.subtitle,
    this.contentPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: title,
      subtitle: subtitle,
      activeColor: AppColors.teal,
      contentPadding: contentPadding,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
