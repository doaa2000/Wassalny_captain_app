import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../domain/entities/ride_request.dart';

/// Passenger summary row (avatar, name, rating, payment) reused on the
/// incoming, navigate, arrived and active-trip screens.
class PassengerTile extends StatelessWidget {
  const PassengerTile({
    super.key,
    required this.request,
    this.subtitle,
    this.avatarSize = 54,
    this.trailing,
  });

  final RideRequest request;
  final String? subtitle;
  final double avatarSize;
  final List<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InitialsAvatar(initials: request.passengerInitials, size: avatarSize, radius: 16),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.passengerName,
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimaryDark),
              ),
              const SizedBox(height: 2),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark))
              else
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                    const SizedBox(width: 3),
                    Text(
                      '${request.passengerRating} · ${request.paymentMethod}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (trailing != null) ...trailing!,
      ],
    );
  }
}

/// Small circular call / message action buttons used next to the passenger.
class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    super.key,
    required this.icon,
    this.filled = false,
    this.onPressed,
  });

  final IconData icon;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.success : AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: filled ? BorderSide.none : const BorderSide(color: AppColors.darkBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, size: 21, color: filled ? AppColors.onSuccess : AppColors.primary),
        ),
      ),
    );
  }
}
