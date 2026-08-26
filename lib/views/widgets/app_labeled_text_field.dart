import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A labeled text field with consistent styling across all screens.
/// Renders a bold [label] above a styled [TextField] with an outline border
/// that changes to [AppColors.teal] when focused.
class AppLabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const AppLabeledTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.coolGray,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.medicalGray, fontSize: 14),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.teal,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.medicalGray, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
