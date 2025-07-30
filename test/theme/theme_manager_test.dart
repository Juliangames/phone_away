import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_away/theme/theme_manager.dart';

void main() {
  group('ThemeManager Tests', () {
    late ThemeManager themeManager;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      themeManager = ThemeManager();
      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('should initialize with system theme by default', () {
      expect(themeManager.themeOption, ThemeOption.system);
      expect(themeManager.themeMode, ThemeMode.system);
    });

    test('should have light and dark themes', () {
      expect(themeManager.lightTheme, isA<ThemeData>());
      expect(themeManager.darkTheme, isA<ThemeData>());
    });

    test('should change theme option to light', () async {
      await themeManager.setThemeOption(ThemeOption.light);
      
      expect(themeManager.themeOption, ThemeOption.light);
      expect(themeManager.themeMode, ThemeMode.light);
      expect(themeManager.isDarkMode, isFalse);
    });

    test('should change theme option to dark', () async {
      await themeManager.setThemeOption(ThemeOption.dark);
      
      expect(themeManager.themeOption, ThemeOption.dark);
      expect(themeManager.themeMode, ThemeMode.dark);
      expect(themeManager.isDarkMode, isTrue);
    });

    test('should persist theme preference', () async {
      await themeManager.setThemeOption(ThemeOption.dark);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme_mode'), ThemeOption.dark.index);
    });

    test('should update system brightness when in system mode', () {
      themeManager.updateSystemBrightness(true);
      expect(themeManager.isDarkMode, isTrue);
      
      themeManager.updateSystemBrightness(false);
      expect(themeManager.isDarkMode, isFalse);
    });

    test('should not update brightness when not in system mode', () async {
      await themeManager.setThemeOption(ThemeOption.light);
      themeManager.updateSystemBrightness(true);
      expect(themeManager.isDarkMode, isFalse);
    });

    test('should return correct current theme', () async {
      await themeManager.setThemeOption(ThemeOption.light);
      expect(themeManager.currentTheme, themeManager.lightTheme);
      
      await themeManager.setThemeOption(ThemeOption.dark);
      expect(themeManager.currentTheme, themeManager.darkTheme);
    });

    test('should notify listeners when theme changes', () async {
      var notified = false;
      themeManager.addListener(() {
        notified = true;
      });
      
      await themeManager.setThemeOption(ThemeOption.dark);
      expect(notified, isTrue);
    });
  });
}
