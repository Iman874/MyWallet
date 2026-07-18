import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base text styles (light theme default)
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle saldo = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle jumlah = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle input = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Context-aware methods for dark mode support
  static TextStyle heading1Context(BuildContext context) => heading1.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle heading2Context(BuildContext context) => heading2.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle heading3Context(BuildContext context) => heading3.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle heading4Context(BuildContext context) => heading4.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle bodyContext(BuildContext context) => body.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle bodySmallContext(BuildContext context) => bodySmall.copyWith(
    color: AppColors.forBrightness(context, AppColors.textSecondary, AppColors.textSecondaryDark),
  );

  static TextStyle captionContext(BuildContext context) => caption.copyWith(
    color: AppColors.forBrightness(context, AppColors.textSecondary, AppColors.textSecondaryDark),
  );

  static TextStyle jumlahContext(BuildContext context) => jumlah.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );

  static TextStyle labelContext(BuildContext context) => label.copyWith(
    color: AppColors.forBrightness(context, AppColors.textSecondary, AppColors.textSecondaryDark),
  );

  static TextStyle inputContext(BuildContext context) => input.copyWith(
    color: AppColors.forBrightness(context, AppColors.textPrimary, AppColors.textPrimaryDark),
  );
}
