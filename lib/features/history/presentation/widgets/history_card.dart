import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/route_indicator.dart';
import '../../domain/entities/trip_history_item.dart';

/// A single completed-trip card in the history list.
class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.item});

  final TripHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: AppCard(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(item.time, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                const Spacer(),
                Text(item.earnings, style: AppTextStyles.statValue.copyWith(color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 11),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const RouteIndicator(),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.from, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                        const SizedBox(height: 13),
                        Text(item.to, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item.distance, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                      Text(item.duration, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 24, color: AppColors.darkDivider),
            Row(
              children: [
                InitialsAvatar(initials: item.passengerInitials, size: 26, radius: 8),
                const SizedBox(width: 7),
                Text(item.passengerName, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark)),
                const Spacer(),
                const Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                const SizedBox(width: 2),
                Text(item.rating, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
