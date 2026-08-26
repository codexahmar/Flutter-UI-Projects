import 'package:flutter/material.dart';

enum AppThemePreference { system, light, dark }

class AppThemeController extends ChangeNotifier {
  AppThemePreference _preference = AppThemePreference.dark;

  AppThemePreference get preference => _preference;

  ThemeMode get themeMode {
    switch (_preference) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  bool isDarkMode(BuildContext context) {
    if (_preference == AppThemePreference.dark) {
      return true;
    }
    if (_preference == AppThemePreference.light) {
      return false;
    }
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  void toggleTheme(BuildContext context) {
    final currentIsDark = isDarkMode(context);
    setPreference(
      currentIsDark ? AppThemePreference.light : AppThemePreference.dark,
    );
  }

  void setPreference(AppThemePreference preference) {
    if (_preference == preference) {
      return;
    }
    _preference = preference;
    notifyListeners();
  }
}
