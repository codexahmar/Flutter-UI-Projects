import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.brandBlue,
      onPrimary: AppColors.white,
      secondary: AppColors.accentTeal,
      onSecondary: AppColors.white,
      error: AppColors.danger,
      onError: AppColors.white,
      surface: AppColors.slate900,
      onSurface: AppColors.white,
      surfaceContainerHighest: AppColors.slate800,
      onSurfaceVariant: AppColors.slate300,
      outline: AppColors.slate700,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.slate900,
      inversePrimary: Color(0xFF89A9FF),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.midnight,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, isDark: true),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.slate900,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.brandBlue.withValues(alpha: 0.16),
        backgroundColor: AppColors.slate900,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.slate500,
          );
        }),
      ),
      dividerColor: AppColors.slate700.withValues(alpha: 0.45),
    );
  }

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.brandBlue,
      onPrimary: AppColors.white,
      secondary: AppColors.accentTeal,
      onSecondary: AppColors.white,
      error: AppColors.danger,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.slate900,
      surfaceContainerHighest: AppColors.slate100,
      onSurfaceVariant: AppColors.slate500,
      outline: AppColors.slate200,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.slate900,
      onInverseSurface: AppColors.white,
      inversePrimary: Color(0xFF89A9FF),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      brightness: Brightness.light,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, isDark: false),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.brandBlue.withValues(alpha: 0.1),
        backgroundColor: AppColors.white,
      ),
      dividerColor: AppColors.slate200,
    );
  }

  static TextTheme _textTheme(TextTheme base, {required bool isDark}) {
    final bodyColor = isDark ? AppColors.slate300 : AppColors.slate500;

    return base.copyWith(
      headlineLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
    );
  }
}
