import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class OnboardingSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class OnboardingRadius {
  static const double sm = 12;
  static const double md = 20;
  static const double pill = 999;
}

abstract final class OnboardingColors {
  static const baseCanvas = Color(0xFF0B0D12);
  static const textPrimary = Color(0xFFF3F5F8);
  static const textSecondary = Color(0xFF9AA3B2);
  static const inkOnAccent = Color(0xFF060B12);
  static const ringTrack = Color(0x24FFFFFF);
  static const sheetSurface = Color(0xFF131620);
  static const sheetSurfaceSubtle = Color(0xFF1B202E);
  static const sheetBorder = Color(0xFF283044);
}

abstract final class OnboardingText {
  static const headline = TextStyle(
    color: OnboardingColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.12,
  );

  static const title = TextStyle(
    color: OnboardingColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.25,
  );

  static const body = TextStyle(
    color: OnboardingColors.textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.48,
  );

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.15,
    height: 1.2,
  );

  static const caption = TextStyle(
    color: OnboardingColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.35,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

abstract final class OnboardingTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: OnboardingColors.baseCanvas,
      colorScheme: const ColorScheme.dark(
        primary: OnboardingColors.textPrimary,
        onPrimary: OnboardingColors.inkOnAccent,
        surface: OnboardingColors.sheetSurface,
        onSurface: OnboardingColors.textPrimary,
        outline: OnboardingColors.sheetBorder,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          headlineMedium: OnboardingText.headline,
          titleMedium: OnboardingText.title,
          bodyMedium: OnboardingText.body,
          bodySmall: OnboardingText.caption,
          labelLarge: OnboardingText.button,
        ),
      ),
    );
  }
}

