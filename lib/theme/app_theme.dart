import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_system.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.favorite,
      onError: Colors.white,
      outline: AppColors.textMuted,
      outlineVariant: Color(0xFFE5E7EB),
    ),
    textTheme: AppTypography.lightTextTheme,
    appBarBackground: AppColors.primary.withValues(alpha: 0.15),
    appBarForeground: AppColors.textPrimary,
    cardColor: AppColors.cardLight,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimary,
      tertiary: AppColors.accentLight,
      onTertiary: AppColors.textPrimary,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textLight,
      error: AppColors.favorite,
      onError: Colors.white,
      outline: AppColors.textMuted,
      outlineVariant: Color(0xFF374151),
    ),
    textTheme: AppTypography.darkTextTheme,
    appBarBackground: AppColors.primaryLight.withValues(alpha: 0.15),
    appBarForeground: AppColors.textLight,
    cardColor: AppColors.cardDark,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required Color appBarBackground,
    required Color appBarForeground,
    required Color cardColor,
    required Brightness statusBarIconBrightness,
    required Brightness statusBarBrightness,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        titleTextStyle: textTheme.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: statusBarBrightness,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shadowColor: Colors.black.withValues(
          alpha: brightness == Brightness.light ? 0.1 : 0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }
}
