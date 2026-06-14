import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/route_indicator.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../trip/domain/entities/ride_request.dart';

/// A nearby ride request preview card on the dashboard sheet.
class NearbyRequestCard extends StatelessWidget {
  const NearbyRequestCard({super.key, required this.request, required this.onTap});

  final RideRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                StatusBadge(label: request.tier, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('${request.pickupEtaMinutes} min away',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark)),
                const Spacer(),
                Text(request.fare, style: AppTextStyles.statValue.copyWith(color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 12),
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
                        Text(request.pickup, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                        const SizedBox(height: 13),
                        Text(request.dropoff, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(request.distance, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                      Text(request.duration, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
