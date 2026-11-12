import 'package:flutter/material.dart';

/// Pinterest Design System Tokens (Base-4 scale, measured AA contrast, elevation roles)
class AppTokens {
  AppTokens._();

  // Spacing scale (Base 4, non-linear steps)
  static const double space2 = 2.0; // Collage hairline gaps only
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0; // Standard screen rail margin
  static const double space20 = 20.0;
  static const double space24 = 24.0; // Group & section breathing gap
  static const double space32 = 32.0;

  // Radii system (uniform across components)
  static const double radiusSm = 10.0; // Thumbnails & compact previews
  static const double radiusPin = 16.0; // Pin & explore cards
  static const double radiusBoard = 16.0; // Board collage container
  static const double radiusTile = 18.0; // Create option squircles
  static const double radiusButton = 24.0; // Action capsules
  static const double radiusPill = 24.0; // Search bar & trend chips
  static const double radiusSheet = 28.0; // Modal bottom sheets

  // Authentic Pinterest Brand Roles
  static const Color pinterestRed = Color(0xFFE60023); // #FFFFFF on #E60023 = 4.78:1 AA
  static const Color pinterestRedDark = Color(0xFFB6001B); // Pressed / destructive emphasis
  static const Color pinterestRedTint = Color(0xFFFDECEE); // 6.13:1 with pinterestRedDark

  // Pinterest Neutral Light Scale (Warm-clean neutrals with measured AA contrast on #FFFFFF)
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF6F6F6); // Loading surface, skeletons, subtle tiles
  static const Color lightPill = Color(0xFFEFEFEF); // Secondary action capsule (#111111 text = 16.42:1)
  static const Color lightPillHover = Color(0xFFE2E2E2);
  static const Color lightPillBorder = Color(0xFFE2E2E2);
  static const Color lightBorder = Color(0xFFEAEAEA); // Hairline section divider
  static const Color lightImageHairline = Color(0x10000000); // Prevents white cutouts bleeding into canvas

  // Ink Scale
  static const Color lightTextPrimary = Color(0xFF111111); // 18.88:1 on #FFFFFF
  static const Color lightTextSecondary = Color(0xFF5F5F5F); // 6.39:1 on #FFFFFF
  static const Color lightTextTertiary = Color(0xFF717171); // 4.88:1 on #FFFFFF (AA compliant)
  static const Color darkSnackbarSurface = Color(0xFF191919);

  // Scrims (Photo text legibility)
  static const Color imageScrimTop = Color(0x00000000);
  static const Color imageScrimMid = Color(0x28000000);
  static const Color imageScrimBottom = Color(0xB8000000);

  // Two-layer elevation shadows (light from above)
  static const List<BoxShadow> shadowBar = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowChrome = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 12,
      offset: Offset(0, -2),
    ),
  ];
}
