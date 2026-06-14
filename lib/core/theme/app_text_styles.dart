import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography. The design uses "Plus Jakarta Sans".
///
/// No widget should hardcode a font size or weight; instead derive from one of
/// these named styles (and recolor with `.copyWith(color: ...)` against the
/// active [Theme]).
abstract final class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(double size, FontWeight weight, {double? height, double? spacing}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
      );

  // Display / headlines
  static TextStyle get display => _base(30, FontWeight.w800, spacing: -0.6);
  static TextStyle get headline => _base(27, FontWeight.w800, spacing: -0.5);
  static TextStyle get title => _base(24, FontWeight.w800, spacing: -0.5);
  static TextStyle get titleSmall => _base(20, FontWeight.w800, spacing: -0.4);

  // Section / card titles
  static TextStyle get sectionTitle => _base(16, FontWeight.w800);
  static TextStyle get cardTitle => _base(15, FontWeight.w800);

  // Body
  static TextStyle get body => _base(14, FontWeight.w600);
  static TextStyle get bodyStrong => _base(14, FontWeight.w700);
  static TextStyle get bodySmall => _base(13, FontWeight.w600);

  // Labels / captions
  static TextStyle get label => _base(12.5, FontWeight.w700);
  static TextStyle get caption => _base(12, FontWeight.w600);
  static TextStyle get overline => _base(11, FontWeight.w700, spacing: 0.5);
  static TextStyle get micro => _base(10.5, FontWeight.w700);

  // Numeric emphasis
  static TextStyle get amountLarge => _base(38, FontWeight.w800, spacing: -1);
  static TextStyle get amountMedium => _base(20, FontWeight.w800, spacing: -0.3);
  static TextStyle get statValue => _base(18, FontWeight.w800, spacing: -0.3);

  // Buttons
  static TextStyle get button => _base(16.5, FontWeight.w800);
  static TextStyle get buttonSmall => _base(14, FontWeight.w700);
}
