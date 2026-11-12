import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get lightTheme {
    const baseTextTheme = TextTheme(
      // Screen display headers (Profile name, Updates title)
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.2,
        color: AppTokens.lightTextPrimary,
      ),
      // Modal / Header titles ("Pinterest", pin closeup title)
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
        color: AppTokens.lightTextPrimary,
      ),
      // Section headings ("Ideas for you", "More like this", "All pins")
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.3,
        color: AppTokens.lightTextPrimary,
      ),
      // Emphasized row/card titles
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: AppTokens.lightTextPrimary,
      ),
      // Primary body / action pill text
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.15,
        height: 1.4,
        color: AppTokens.lightTextPrimary,
      ),
      // Descriptions & board titles
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.35,
        color: AppTokens.lightTextSecondary,
      ),
      // Compact pin card titles & secondary captions
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.05,
        height: 1.3,
        color: AppTokens.lightTextSecondary,
      ),
      // Pills, tabs & buttons
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.2,
        color: AppTokens.lightTextPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.25,
        color: AppTokens.lightTextSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.25,
        color: AppTokens.lightTextTertiary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppTokens.lightBg,
      splashFactory: NoSplash.splashFactory,
      highlightColor: AppTokens.lightSurfaceSubtle.withValues(alpha: 0.7),
      splashColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        surface: AppTokens.lightSurface,
        surfaceContainerHighest: AppTokens.lightPill,
        primary: AppTokens.pinterestRed,
        onPrimary: Colors.white,
        onSurface: AppTokens.lightTextPrimary,
        onSurfaceVariant: AppTokens.lightTextSecondary,
        outline: AppTokens.lightBorder,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppTokens.pinterestRed,
        selectionColor: AppTokens.pinterestRed.withValues(alpha: 0.16),
        selectionHandleColor: AppTokens.pinterestRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTokens.lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppTokens.lightTextPrimary),
        titleTextStyle: TextStyle(
          color: AppTokens.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppTokens.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTokens.radiusSheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTokens.darkSnackbarSurface,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
        ),
      ),
      textTheme: baseTextTheme,
    );
  }
}
