import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.secondary,
        foregroundColor: AppColorsLight.onPrimary,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headline1,
        bodyMedium: AppTextStyles.bodyText,
        labelSmall: AppTextStyles.caption,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsLight.primary,
        brightness: Brightness.light,
        surface: AppColorsLight.surface,
        secondary: AppColorsLight.secondary,
        error: AppColorsLight.error,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.secondary,
        foregroundColor: AppColorsDark.onPrimary,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headline1,
        bodyMedium: AppTextStyles.bodyText,
        labelSmall: AppTextStyles.caption,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsDark.primary,
        brightness: Brightness.dark,
        surface: AppColorsDark.surface,
        secondary: AppColorsDark.secondary,
        error: AppColorsDark.error,
      ),
    );
  }
}
