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
  static const textPrimary = Color(0xFFF4F7FB);
  static const textSecondary = Color(0xFF9EABC0);
  static const inkOnAccent = Color(0xFF061019);
  static const hairline = Color(0x26FFFFFF);
  static const sheetSurface = Color(0xFF141824);
  static const sheetSurfaceSubtle = Color(0xFF1C2233);
  static const sheetBorder = Color(0xFF2B344A);
}

class OnboardingPalette {
  final Color canvas;
  final Color surface;
  final Color border;
  final Color accent;
  final Color secondaryText;

  const OnboardingPalette({
    required this.canvas,
    required this.surface,
    required this.border,
    required this.accent,
    required this.secondaryText,
  });
}

abstract final class OnboardingText {
  static const headline = TextStyle(
    color: OnboardingColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    height: 1.14,
  );

  static const title = TextStyle(
    color: OnboardingColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
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
    letterSpacing: -0.1,
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
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: OnboardingColors.sheetSurface,
      colorScheme: const ColorScheme.dark(
        primary: OnboardingColors.textPrimary,
        onPrimary: OnboardingColors.inkOnAccent,
        surface: OnboardingColors.sheetSurface,
        onSurface: OnboardingColors.textPrimary,
        outline: OnboardingColors.sheetBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineMedium: OnboardingText.headline,
          titleMedium: OnboardingText.title,
          bodyMedium: OnboardingText.body,
          bodySmall: OnboardingText.caption,
          labelLarge: OnboardingText.button,
        ),
      ),
    );

    return baseTheme;
  }
}

