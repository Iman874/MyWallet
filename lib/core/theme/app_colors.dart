import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary (same for both themes)
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Status (same for both themes)
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);

  // Common
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);

  // Light theme colors (default)
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color greyLight = Color(0xFFF1F5F9);

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF1E1E2E);
  static const Color cardDark = Color(0xFF2A2A3C);
  static const Color borderDark = Color(0xFF3A3A4C);
  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color greyLightDark = Color(0xFF334155);

  /// Get appropriate color based on theme brightness
  static Color forBrightness(BuildContext context, Color light, Color dark) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
