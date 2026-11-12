import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class FoodSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class FoodRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double pill = 999;
}

abstract final class FoodColors {
  static const canvas = Color(0xFF0C0E12);
  static const surface = Color(0xFF141820);
  static const surfaceSubtle = Color(0xFF1C222D);
  static const border = Color(0xFF283040);

  static const textPrimary = Color(0xFFF5F7FA);
  static const textSecondary = Color(0xFF9BA4B5);

  static const accent = Color(0xFFFF9B42);
  static const accentTint = Color(0xFF2A1D11);
  static const accentBorder = Color(0xFF6B421A);
  static const inkOnAccent = Color(0xFF140B02);

  static const success = Color(0xFF34D399);
  static const successTint = Color(0xFF0E2921);
  static const inkOnSuccess = Color(0xFF051811);

  static const mapRoadCasing = Color(0xFF080A0D);
  static const mapRoad = Color(0xFF1B212C);
  static const mapBlock = Color(0xFF12161E);
  static const mapLabel = Color(0xFF7B8599);
  static const shadow = Color(0x66020408);
}

abstract final class FoodText {
  static const headline = TextStyle(
    color: FoodColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    height: 1.15,
  );

  static const title = TextStyle(
    color: FoodColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const body = TextStyle(
    color: FoodColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const caption = TextStyle(
    color: FoodColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.35,
  );

  static const tabular = TextStyle(
    color: FoodColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.15,
    height: 1.2,
  );
}

abstract final class AppTheme {
  static ThemeData dark() {
    const pillShape = StadiumBorder();
    const minButtonSize = Size(0, 48);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FoodColors.canvas,
      colorScheme: const ColorScheme.dark(
        primary: FoodColors.accent,
        onPrimary: FoodColors.inkOnAccent,
        secondary: FoodColors.success,
        onSecondary: FoodColors.inkOnSuccess,
        surface: FoodColors.surface,
        onSurface: FoodColors.textPrimary,
        outline: FoodColors.border,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          headlineMedium: FoodText.headline,
          titleMedium: FoodText.title,
          bodyMedium: FoodText.body,
          bodySmall: FoodText.caption,
          labelLarge: FoodText.button,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: FoodColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FoodColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FoodSpacing.lg,
          vertical: FoodSpacing.md,
        ),
        hintStyle: FoodText.caption.copyWith(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodRadius.pill),
          borderSide: const BorderSide(color: FoodColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodRadius.pill),
          borderSide: const BorderSide(color: FoodColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodRadius.pill),
          borderSide: const BorderSide(color: FoodColors.accent, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: FoodColors.accent,
          foregroundColor: FoodColors.inkOnAccent,
          minimumSize: minButtonSize,
          padding: const EdgeInsets.symmetric(horizontal: FoodSpacing.xl),
          shape: pillShape,
          textStyle: FoodText.button,
          elevation: 0,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: FoodColors.surface,
          foregroundColor: FoodColors.textPrimary,
          minimumSize: const Size.square(48),
          side: const BorderSide(color: FoodColors.border),
        ),
      ),
    );
  }
}

