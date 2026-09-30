import 'package:flutter/material.dart';

/// 大赛演示风格：气象蓝白、简洁大气。
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF0B6E99);
  static const Color primaryDark = Color(0xFF085578);
  static const Color surface = Color(0xFFF5F9FC);
  static const Color userBubble = Color(0xFF0B6E99);
  static const Color aiBubble = Color(0xFFFFFFFF);
  static const Color recording = Color(0xFFE53935);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
