import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Consistent spacing rhythm across discovery, checkout, and tracking.
abstract final class FoodSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Consistent corner radius scale.
abstract final class FoodRadius {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 999;
}

/// Cohesive 3-color editorial palette: Warm Ivory, Deep Espresso, and Terracotta Ember.
abstract final class FoodColors {
  // 1. Warm Ivory neutrals
  static const canvas = Color(0xFFFAF7F2);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF1EBE2);
  static const border = Color(0xFFE7DFD4);

  // 2. Deep Espresso typography & dark surfaces
  static const textPrimary = Color(0xFF171310);
  static const textSecondary = Color(0xFF6B6259);
  static const inkOnDark = Color(0xFFFFFFFF);

  // 3. Terracotta Ember signature accent
  static const accent = Color(0xFFD93F1E);
  static const accentTint = Color(0xFFFDEEE9);
  static const accentInk = Color(0xFF9F280E);
  static const inkOnAccent = Color(0xFFFFFFFF);

  // Harmonized warm monochrome cartography tokens (strictly within the 3-color family)
  static const mapLand = Color(0xFFF0EAE0);
  static const mapPark = Color(0xFFE6DFD3);
  static const mapParkTree = Color(0xFFD7CFC1);
  static const mapWater = Color(0xFFE5DDD1);
  static const mapBuilding = Color(0xFFE2DAD0);
  static const mapBuildingTop = Color(0xFFFFFFFF);
  static const mapBuildingBorder = Color(0xFFD6CEC2);
  static const mapRoadCasing = Color(0xFFDAD2C6);
  static const mapRoadMinor = Color(0xFFFAF8F4);
  static const mapRoadMajor = Color(0xFFFFFFFF);
  static const mapLabel = Color(0xFF5D544B);
  static const mapStreetLabel = Color(0xFF7D7369);
  static const shadow = Color(0x14171310);
}

/// Disciplined Plus Jakarta Sans typography scale restricted to medium & bold weights.
abstract final class FoodText {
  static TextStyle get headline => GoogleFonts.plusJakartaSans(
        color: FoodColors.textPrimary,
        fontSize: 27,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.85,
        height: 1.14,
      );

  static TextStyle get title => GoogleFonts.plusJakartaSans(
        color: FoodColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
        height: 1.24,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        color: FoodColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        height: 1.42,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        color: FoodColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.35,
      );

  static TextStyle get tabular => GoogleFonts.plusJakartaSans(
        color: FoodColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.2,
      );
}

abstract final class AppTheme {
  static ThemeData light() {
    const pillShape = StadiumBorder();
    const minButtonSize = Size(0, 48);

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(
      TextTheme(
        headlineMedium: FoodText.headline,
        titleMedium: FoodText.title,
        bodyMedium: FoodText.body,
        bodySmall: FoodText.caption,
        labelLarge: FoodText.button,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: FoodColors.canvas,
      colorScheme: const ColorScheme.light(
        primary: FoodColors.accent,
        onPrimary: FoodColors.inkOnAccent,
        secondary: FoodColors.textPrimary,
        onSecondary: FoodColors.inkOnDark,
        surface: FoodColors.surface,
        onSurface: FoodColors.textPrimary,
        outline: FoodColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FoodColors.canvas,
        foregroundColor: FoodColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: FoodText.title,
      ),
      textTheme: baseTextTheme,
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
          vertical: FoodSpacing.md + 1,
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
          borderSide: const BorderSide(
            color: FoodColors.textPrimary,
            width: 1.4,
          ),
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
          minimumSize: const Size.square(44),
          side: const BorderSide(color: FoodColors.border),
        ),
      ),
    );
  }
}
