import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Square gradient avatar showing a person's initials. Used for the captain
/// and passengers throughout the app.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 46,
    this.radius = 14,
    this.gradient = AppColors.passengerGradient,
    this.foreground = AppColors.white,
  });

  /// Convenience for the captain's blue avatar.
  const InitialsAvatar.captain({
    super.key,
    required this.initials,
    this.size = 46,
    this.radius = 14,
  })  : gradient = AppColors.primaryGradient,
        foreground = AppColors.onPrimary;

  final String initials;
  final double size;
  final double radius;
  final Gradient gradient;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        initials,
        style: AppTextStyles.bodyStrong.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.32,
        ),
      ),
    );
  }
}
