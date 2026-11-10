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

  // Light Mode (Crisp White + Soft Neutral Grays)
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPill = Color(0xFFE9E9E9);
  static const Color lightPillHover = Color(0xFFDADADA);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextTertiary = Color(0xFF8E8E8E);

  // Dark Mode (Deep Charcoal + Elevated Pitch Surface)
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1C1C1C);
  static const Color darkPill = Color(0xFF2B2B2B);
  static const Color darkPillHover = Color(0xFF383838);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB5B5B5);
  static const Color darkTextTertiary = Color(0xFF757575);
}
