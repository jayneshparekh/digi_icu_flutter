import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color navy = Color(0xFF07183A); // Primary background, headings, strong text
  static const Color blue = Color(0xFF1D7CF8); // Links, icons, highlights, brand emphasis
  static const Color teal = Color(0xFF00CFC8); // Accent color, CTA, ICU symbol, graphs
  static const Color white = Color(0xFFFFFFFF); // Clean backgrounds, reverse logo

  // Supporting Colors
  static const Color medicalGray = Color(0xFFBFC7D5); // Borders, dividers, subtle lines
  static const Color coolGray = Color(0xFF6F7D92); // Secondary text, icons, captions
  static const Color lightGray = Color(0xFFEEF3F8); // Section backgrounds, surfaces
  static const Color pureBlack = Color(0xFF111111); // Print text, high contrast use only

  // Functional Colors
  static const Color success = Color(0xFF00867A);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [blue, teal],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [navy, blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
