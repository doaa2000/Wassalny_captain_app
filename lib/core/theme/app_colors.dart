import 'package:flutter/material.dart';

/// Centralized color palette for the Wassalny Captain app.
///
/// No widget should ever hardcode a [Color]. All colors are derived from the
/// design system and exposed here so that theming (light/dark) and future
/// rebrands only require touching a single file.
abstract final class AppColors {
  AppColors._();

  // ---- Brand / accent (Captain blue) ----
  static const Color primary = Color(0xFF67B2D8);
  static const Color primaryDark = Color(0xFF4E9DC6);
  static const Color primaryDeep = Color(0xFF3C86AE);

  /// Foreground used on top of [primary] filled surfaces (buttons).
  static const Color onPrimary = Color(0xFF06212E);

  // ---- Semantic ----
  static const Color success = Color(0xFF2FD27D);
  static const Color onSuccess = Color(0xFF06241A);
  static const Color warning = Color(0xFFF5B544);
  static const Color danger = Color(0xFFFF5247);
  static const Color dangerSoft = Color(0xFFFF7A6E);

  // ---- Passenger / incentive accent (purple) ----
  static const Color accentPurple = Color(0xFF8E7BE6);
  static const Color accentPurpleDark = Color(0xFF6B5BD0);
  static const Color accentPurpleSoft = Color(0xFFA99BF0);

  // ---- Dark theme neutrals ----
  static const Color darkBackground = Color(0xFF0E141A);
  static const Color darkBackgroundDeep = Color(0xFF04070A);
  static const Color darkSurface = Color(0xFF18222C);
  static const Color darkSurfaceAlt = Color(0xFF131C24);
  static const Color darkSurfaceRail = Color(0xFF141C24);
  static const Color darkBorder = Color(0xFF283642);
  static const Color darkBorderSoft = Color(0xFF233140);
  static const Color darkDivider = Color(0xFF1E2832);
  static const Color darkTrack = Color(0xFF2C3A47);

  // ---- Light theme neutrals ----
  static const Color lightBackground = Color(0xFFF2F6F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEDF2F6);
  static const Color lightBorder = Color(0xFFD7E0E8);
  static const Color lightDivider = Color(0xFFE3EAF0);

  // ---- Text ----
  static const Color textPrimaryDark = Color(0xFFF2F6F9);
  static const Color textSecondaryDark = Color(0xFF93A3B0);
  static const Color textMutedDark = Color(0xFF647483);
  static const Color textFaintDark = Color(0xFF3C4A57);

  static const Color textPrimaryLight = Color(0xFF0E141A);
  static const Color textSecondaryLight = Color(0xFF5A6B79);
  static const Color textMutedLight = Color(0xFF8A99A6);

  // ---- Overlays / misc ----
  static const Color overlay = Color(0x8C080C10);
  static const Color white = Color(0xFFFFFFFF);

  // ---- Gradients ----
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDeep],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1F8A5B), Color(0xFF0E6B45)],
  );

  static const LinearGradient passengerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, accentPurpleDark],
  );
}
