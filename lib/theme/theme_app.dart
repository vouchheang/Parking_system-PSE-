import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF116692);
  static const Color secondaryColor = Color(0xFFF19417);
  static const Color accentColor = Color(0xFFF0F7FD);
  static const Color textColor = Color(0xFFD9D9D9);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
