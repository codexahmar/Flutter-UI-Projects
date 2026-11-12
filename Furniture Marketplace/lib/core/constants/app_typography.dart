import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle detailTitle({Color color = AppColors.pureBlack}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: -0.4,
    );
  }

  static TextStyle cardTitle({Color color = AppColors.pureBlack}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle priceBold({
    Color color = AppColors.pureBlack,
    double fontSize = 16,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: -0.3,
    );
  }

  static TextStyle discountBadge({Color color = Colors.white}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle bodyMuted({Color color = AppColors.mutedGray}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
    );
  }
}
