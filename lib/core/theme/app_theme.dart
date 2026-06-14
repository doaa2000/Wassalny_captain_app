import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the light and dark [ThemeData] for the app from the centralized
/// design tokens. The design ships dark-first; the light variant mirrors the
/// same structure with light neutrals.
abstract final class AppTheme {
  AppTheme._();

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 22;
  static const double radiusXl = 28;

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        border: AppColors.darkBorder,
        textPrimary: AppColors.textPrimaryDark,
        textSecondary: AppColors.textSecondaryDark,
        textMuted: AppColors.textMutedDark,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        border: AppColors.lightBorder,
        textPrimary: AppColors.textPrimaryLight,
        textSecondary: AppColors.textSecondaryLight,
        textMuted: AppColors.textMutedLight,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.success,
      onSecondary: AppColors.onSuccess,
      error: AppColors.danger,
      onError: AppColors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    final textTheme = TextTheme(
      displayLarge: AppTextStyles.display.copyWith(color: textPrimary),
      headlineLarge: AppTextStyles.headline.copyWith(color: textPrimary),
      headlineMedium: AppTextStyles.title.copyWith(color: textPrimary),
      titleLarge: AppTextStyles.titleSmall.copyWith(color: textPrimary),
      titleMedium: AppTextStyles.sectionTitle.copyWith(color: textPrimary),
      titleSmall: AppTextStyles.cardTitle.copyWith(color: textPrimary),
      bodyLarge: AppTextStyles.body.copyWith(color: textPrimary),
      bodyMedium: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      bodySmall: AppTextStyles.caption.copyWith(color: textMuted),
      labelLarge: AppTextStyles.button.copyWith(color: AppColors.onPrimary),
      labelMedium: AppTextStyles.label.copyWith(color: textPrimary),
      labelSmall: AppTextStyles.overline.copyWith(color: textMuted),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      dividerColor: brightness == Brightness.dark
          ? AppColors.darkDivider
          : AppColors.lightDivider,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: AppTextStyles.title.copyWith(color: textPrimary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd + 2),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        hintStyle: AppTextStyles.body.copyWith(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm + 3),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm + 3),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm + 3),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
