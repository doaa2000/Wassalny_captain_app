import 'package:flutter/material.dart';

/// Centralized color palette for the Wassalny Captain app.
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand / Captain Identity (Purple)
  // ---------------------------------------------------------------------------

  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryDeep = Color(0xFF5B21B6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primarySoft = Color(0xFFC4B5FD);

  /// Foreground used on top of primary surfaces.
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------

static const Color success = Color(0xFF10B981);  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFF59E0B);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0xFFFCA5A5);

  // ---------------------------------------------------------------------------
  // Accent / Secondary Purple Shades
  // ---------------------------------------------------------------------------

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleDark = Color(0xFF7C3AED);
  static const Color accentPurpleSoft = Color(0xFFC4B5FD);

  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkBackgroundDeep = Color(0xFF020617);

  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceAlt = Color(0xFF273449);
  static const Color darkSurfaceRail = Color(0xFF334155);

  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderSoft = Color(0xFF475569);

  static const Color darkDivider = Color(0xFF334155);
  static const Color darkTrack = Color(0xFF475569);

  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------

  static const Color lightBackground = Color(0xFFF8FAFC);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F5F9);

  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color textFaintDark = Color(0xFF64748B);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // ---------------------------------------------------------------------------
  // Misc
  // ---------------------------------------------------------------------------

  static const Color overlay = Color(0x8C080C10);
  static const Color white = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      primaryDark,
    ],
  );

  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      primaryDeep,
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
   colors: [
  Color(0xFF34D399),
  Color(0xFF10B981),
]
  );

  static const LinearGradient passengerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryLight,
      primary,
    ],
  );
}