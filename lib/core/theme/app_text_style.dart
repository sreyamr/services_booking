import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';


class AppTextStyles {
  static final title = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );


  static final body = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static final button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle subtitle = const TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle categoryTitle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static TextStyle poppinsSemiBold({
    double fontSize = 14,
    Color color = AppColors.textDark,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Poppins Bold (700)
  static TextStyle poppinsBold({
    double fontSize = 14,
    Color color = AppColors.textDark,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      );
}