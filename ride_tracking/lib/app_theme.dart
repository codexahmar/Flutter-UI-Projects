import 'package:flutter/material.dart';

abstract final class RideColors {
  static const canvas = Color(0xFF0C1014);
  static const mapBlock = Color(0xFF13191F);
  static const mapPark = Color(0xFF111D19);
  static const mapWater = Color(0xFF0E1822);
  static const mapLabel = Color(0xFF566370);
  static const mapRoadCasing = Color(0xFF080B0E);
  static const mapRoadMinor = Color(0xFF1A222A);
  static const mapRoadMajor = Color(0xFF222C36);

  static const surface = Color(0xFF14191F);
  static const surfaceSubtle = Color(0xFF1E262E);
  static const border = Color(0xFF28323C);

  static const textPrimary = Color(0xFFF1F5F8);
  static const textSecondary = Color(0xFF96A2AE);

  static const accent = Color(0xFF34D399);
  static const accentTint = Color(0xFF132D23);
  static const inkOnAccent = Color(0xFF071A12);
  static const inkOnLight = Color(0xFF0C1014);
  static const routeTrack = Color(0xFF2E3A46);
  static const rating = Color(0xFFF5B942);

  static const carBody = Color(0xFFF1F5F8);
  static const ambientCarBody = Color(0xFF546270);
  static const carCabin = Color(0xFF10161C);
  static const carTrim = Color(0xFFD6DEE6);
  static const carTaillight = Color(0xFFDC2626);

  static const customerSkin = Color(0xFFE7C2A6);
  static const customerHair = Color(0xFF1B242E);
  static const ambientRider = Color(0xFF64748B);
  static const shadow = Color(0x5A000000);
}

abstract final class RideSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class RideRadius {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

abstract final class RideText {
  static const hero = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.05,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const title = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const body = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.2,
  );

  static const caption = TextStyle(
    color: RideColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static const captionTabular = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.35,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

abstract final class RideTheme {
  static const cardDecoration = BoxDecoration(
    color: RideColors.surface,
    borderRadius: BorderRadius.all(Radius.circular(RideRadius.lg)),
    border: Border.fromBorderSide(BorderSide(color: RideColors.border)),
    boxShadow: [
      BoxShadow(color: RideColors.shadow, blurRadius: 20, offset: Offset(0, 8)),
    ],
  );

  static ThemeData dark() {
    const pillShape = StadiumBorder();
    const minButtonSize = Size(0, 48);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RideColors.canvas,
      colorScheme: const ColorScheme.dark(
        primary: RideColors.accent,
        onPrimary: RideColors.inkOnAccent,
        surface: RideColors.surface,
        onSurface: RideColors.textPrimary,
        outline: RideColors.border,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: RideColors.surface,
          foregroundColor: RideColors.textPrimary,
          minimumSize: const Size.square(48),
          iconSize: 20,
          side: const BorderSide(color: RideColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: RideColors.textPrimary,
          foregroundColor: RideColors.inkOnLight,
          disabledBackgroundColor: RideColors.surfaceSubtle,
          disabledForegroundColor: RideColors.textSecondary,
          minimumSize: minButtonSize,
          padding: const EdgeInsets.symmetric(horizontal: RideSpacing.lg),
          shape: pillShape,
          textStyle: RideText.button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: RideColors.surfaceSubtle,
          foregroundColor: RideColors.textPrimary,
          minimumSize: minButtonSize,
          padding: const EdgeInsets.symmetric(horizontal: RideSpacing.lg),
          shape: pillShape,
          side: const BorderSide(color: RideColors.border),
          textStyle: RideText.button,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: RideColors.accent,
        selectionColor: RideColors.accent.withValues(alpha: 0.25),
        selectionHandleColor: RideColors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: RideColors.surfaceSubtle,
        contentTextStyle: RideText.body,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RideRadius.md),
          side: const BorderSide(color: RideColors.border),
        ),
      ),
    );
  }
}
