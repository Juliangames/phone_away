import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_light_theme.dart';
import 'app_dark_theme.dart';

enum ThemeOption { light, dark, system }

class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeOption _themeOption = ThemeOption.system;
  bool _isDarkMode = false;

  ThemeOption get themeOption => _themeOption;
  bool get isDarkMode => _isDarkMode;
  ThemeData get currentTheme => _isDarkMode ? appDarkTheme : appLightTheme;
  ThemeData get lightTheme => appLightTheme;
  ThemeData get darkTheme => appDarkTheme;

  ThemeMode get themeMode {
    switch (_themeOption) {
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
      case ThemeOption.system:
        return ThemeMode.system;
    }
  }

  ThemeManager() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeOption.system.index;
    _themeOption = ThemeOption.values[themeIndex];
    _updateDarkMode();
    notifyListeners();
  }

  void _updateDarkMode() {
    if (_themeOption == ThemeOption.system) {
      _isDarkMode = false; // Will be updated by system brightness
    } else {
      _isDarkMode = _themeOption == ThemeOption.dark;
    }
  }

  Future<void> setThemeOption(ThemeOption option) async {
    if (_themeOption != option) {
      _themeOption = option;
      _updateDarkMode();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, option.index);
      notifyListeners();
    }
  }

  void updateSystemBrightness(bool isSystemDark) {
    if (_themeOption == ThemeOption.system) {
      final newDarkMode = isSystemDark;
      if (_isDarkMode != newDarkMode) {
        _isDarkMode = newDarkMode;
        notifyListeners();
      }
    }
  }
}
