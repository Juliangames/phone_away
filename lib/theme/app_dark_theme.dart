import 'package:flutter/material.dart';

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF84D6C2),
    primaryContainer: Color(0xFF005048),
    onPrimary: Color(0xFF003730),
    surface: Color(0xFF0F1512),
    onSurface: Color(0xFFE1E3DE),
    onSurfaceVariant: Color(0xFFBFC9C2),
    surfaceContainerHighest: Color(0xFF2B312D),
    secondary: Color(0xFFB1CCC4),
    secondaryContainer: Color(0xFF374B44),
    onSecondaryContainer: Color(0xFFCDE8E0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    outline: Color(0xFF899389),
    shadow: Color(0xFF000000),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0F1512),
  cardColor: const Color(0xFF1A1F1B),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F1512),
    foregroundColor: Color(0xFFE1E3DE),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0F1512),
    selectedItemColor: Color(0xFF84D6C2),
    unselectedItemColor: Color(0xFF899389),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);
