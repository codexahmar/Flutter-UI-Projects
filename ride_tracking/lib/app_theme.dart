import 'package:flutter/material.dart';

abstract final class RideColors {
  static const canvas = Color(0xFF0D1114);
  static const mapBlock = Color(0xFF141A1F);
  static const mapRoadMinor = Color(0xFF1A2228);
  static const mapRoadMajor = Color(0xFF222B33);
  static const mapLandmark = Color(0xFF28333D);

  static const surface = Color(0xFF161C21);
  static const surfaceSubtle = Color(0xFF202830);
  static const border = Color(0xFF2B353E);

  static const textPrimary = Color(0xFFF1F5F8);
  static const textSecondary = Color(0xFF9BA7B2);

  static const accent = Color(0xFF34D399);
  static const accentTint = Color(0xFF132E24);
  static const inkOnAccent = Color(0xFF071A12);
  static const routeTrack = Color(0xFF2F3B45);
  static const rating = Color(0xFFF5B942);
  static const shadow = Color(0x52000000);
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
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

abstract final class RideText {
  static const hero = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.1,
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
    fontWeight: FontWeight.w400,
    height: 1.35,
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
      BoxShadow(color: RideColors.shadow, blurRadius: 16, offset: Offset(0, 6)),
    ],
  );

  static ThemeData dark() {
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
          backgroundColor: RideColors.surfaceSubtle,
          foregroundColor: RideColors.textPrimary,
          minimumSize: const Size.square(48),
          iconSize: 20,
          side: const BorderSide(color: RideColors.border),
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
