import 'package:flutter/material.dart';

/// Pinterest Design System Tokens
class AppTokens {
  AppTokens._();

  // Spacing scale (Base 4)
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Pinterest Radii
  static const double radiusPin = 16.0; // Pin cards
  static const double radiusBoard = 16.0; // Board collage
  static const double radiusPill = 24.0; // Search bar & chips
  static const double radiusButton = 24.0; // Save & action buttons

  // Authentic Pinterest Color Palette
  static const Color pinterestRed = Color(0xFFE60023); // The iconic Pinterest Red
  static const Color pinterestRedDark = Color(0xFFB6001B);

  // Pinterest Light Color Palette (Crisp Pure White + Clean Soft Neutrals)
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPill = Color(0xFFF0F0F0); // Clean, airy Pinterest soft neutral (never murky grey)
  static const Color lightPillHover = Color(0xFFE5E5E5);
  static const Color lightPillBorder = Color(0xFFE2E2E2);
  static const Color lightBorder = Color(0xFFEAEAEA); // Subtle hair-thin divider
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextTertiary = Color(0xFF8E8E8E);
}
