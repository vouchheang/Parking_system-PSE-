import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2AAF61);
  static const Color secondaryColor = Color(0xFF1E3D59);
  static const Color accentColor = Color(0xFF00C6AE);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1A1D1E);
  static const Color subtitleColor = Color(0xFF6C7072);
  static const Color dividerColor = Color(0xFFE8ECF4);
  
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
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
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: subtitleColor,
      ),
    ),
  );
}