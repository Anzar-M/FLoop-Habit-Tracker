import 'package:flutter/material.dart';

// currently not using this vvv background color; maybe in future version
const Color _backgroundColor = Color(0xFF041E16);
const Color _primaryColor = Color(0xFF7EEECF);
const Color _secondaryColor = Color(0xFF971439);
const Color _accentColor = Color(0xFFE4BA2F);

class AppColors {
  static const Color background = _backgroundColor;
  static const Color completed = _primaryColor;
  static const Color notCompleted = _secondaryColor;
  static const Color button = _primaryColor;
  static const Color header = _accentColor;
  static const Color habitName = _accentColor;
}

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: AppColors.button,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.button,
    foregroundColor: _backgroundColor,
    elevation: 0,
  ),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    primary: AppColors.button,
    secondary: AppColors.header,
    seedColor: AppColors.button,
    surface: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.button,
      foregroundColor: _backgroundColor,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  // scaffoldBackgroundColor: AppColors.background,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: AppColors.button.withOpacity(0.9),
  appBarTheme: AppBarTheme(
    // backgroundColor: AppColors.background,
     backgroundColor: Colors.black,
    // foregroundColor: AppColors.habitName,
    elevation: 0,
  ),

  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    primary: AppColors.button,
    secondary: AppColors.header,
    seedColor: AppColors.button,
    surface: AppColors.background,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.button.withOpacity(0.7),
      foregroundColor: AppColors.background,
    ),
  ),
);

