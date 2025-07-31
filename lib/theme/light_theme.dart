import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF066B5B),
    primaryContainer: Color(0xFFA0F2DE),
    onPrimary: Color(0xFFF5FBF7),
    surface: Color(0xFFF5FBF7),
    onSurface: Color(0xFF191C19),
    onSurfaceVariant: Color(0xFF3F4946),
    surfaceContainerHighest: Color(0xFFDEE4E0),
    secondary: Color(0xFF4F635D),
    secondaryContainer: Color(0xFFCDE8E0),
    onSecondaryContainer: Color(0xFF0A1F1A),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    outline: Color(0xFF6F7972),
    shadow: Color(0xFF000000),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF2F7F3),
  cardColor: const Color(0xFFFFFFFF),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF2F7F3),
    foregroundColor: Color(0xFF191C19),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF2F7F3),
    selectedItemColor: Color(0xFF066B5B),
    unselectedItemColor: Color(0xFF6F7972),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);
