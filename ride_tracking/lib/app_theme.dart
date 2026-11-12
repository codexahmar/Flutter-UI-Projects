import 'package:flutter/material.dart';

abstract final class RideColors {
  static const canvas = Color(0xFF0A0F18);
  static const mapBlock = Color(0xFF121A28);
  static const mapHouse = Color(0xFF152031);
  static const mapShop = Color(0xFF182234);
  static const mapAwning = Color(0xFF38BDF8);
  static const mapBuildingBorder = Color(0xFF24334C);
  static const mapPark = Color(0xFF0E2126);
  static const mapParkCanopy = Color(0xFF16343A);
  static const mapLabel = Color(0xFF7E91B0);
  static const mapParkLabel = Color(0xFF5CA6A8);
  static const mapWater = Color(0xFF0B1C2D);
  static const mapRoadCasing = Color(0xFF060A10);
  static const mapRoadMinor = Color(0xFF172030);
  static const mapRoadMajor = Color(0xFF212E45);

  static const surface = Color(0xFF111827);
  static const surfaceSubtle = Color(0xFF1A2438);
  static const border = Color(0xFF2A3954);

  static const textPrimary = Color(0xFFF3F7FC);
  static const textSecondary = Color(0xFF93A5C2);

  static const accent = Color(0xFF38BDF8);
  static const accentTint = Color(0xFF102A43);
  static const accentBorder = Color(0xFF225D8F);
  static const inkOnAccent = Color(0xFF041320);
  static const routeTrack = Color(0xFF283A57);
  static const rating = Color(0xFFFBBF24);

  static const carBody = Color(0xFFF3F7FC);
  static const ambientCarBody = Color(0xFF4F6280);
  static const carCabin = Color(0xFF0A101A);
  static const carTrim = Color(0xFFD2DFEF);
  static const carTaillight = Color(0xFFEF4444);

  static const customerSkin = Color(0xFFE7C2A6);
  static const customerHair = Color(0xFF141B29);
  static const ambientRider = Color(0xFF607494);
  static const shadow = Color(0x7002050B);
}

abstract final class RideSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
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
    fontSize: 23,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.6,
    height: 1.05,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const title = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.22,
  );

  static const body = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.32,
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
    letterSpacing: 0.05,
    height: 1.35,
  );

  static const captionTabular = TextStyle(
    color: RideColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
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

  static const sheetDecoration = BoxDecoration(
    color: RideColors.surface,
    borderRadius: BorderRadius.vertical(top: Radius.circular(RideRadius.lg)),
    border: Border.fromBorderSide(BorderSide(color: RideColors.border)),
    boxShadow: [
      BoxShadow(color: RideColors.shadow, blurRadius: 24, offset: Offset(0, -6)),
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
      textTheme: const TextTheme(
        headlineMedium: RideText.hero,
        titleMedium: RideText.title,
        bodyMedium: RideText.body,
        bodySmall: RideText.caption,
        labelLarge: RideText.button,
        labelMedium: RideText.captionTabular,
      ),
      dividerTheme: const DividerThemeData(
        color: RideColors.border,
        thickness: 1,
        space: 1,
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
          backgroundColor: RideColors.accent,
          foregroundColor: RideColors.inkOnAccent,
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
    );
  }
}
