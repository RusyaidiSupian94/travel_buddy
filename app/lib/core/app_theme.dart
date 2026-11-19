import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.ink,
      secondary: AppColors.teal,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.15,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          height: 1.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7FAF7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.4),
        ),
        hintStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tealDark,
          side: const BorderSide(color: AppColors.teal),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
      ),
    );
  }
}
