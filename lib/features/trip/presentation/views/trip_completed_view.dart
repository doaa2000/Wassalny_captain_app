import 'package:flutter/material.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/route_indicator.dart';
import '../../domain/entities/fare_breakdown.dart';
import '../../domain/entities/ride_request.dart';

/// Settlement / receipt screen shown after completing a trip.
class TripCompletedView extends StatelessWidget {
  const TripCompletedView({
    super.key,
    required this.request,
    required this.fare,
    required this.onFindNext,
  });

  final RideRequest request;
  final FareBreakdown fare;
  final VoidCallback onFindNext;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.darkBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 36, 24, 34),
            decoration: const BoxDecoration(
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: AppColors.white, size: 34),
                ),
                const SizedBox(height: 14),
                Text(l.youEarned,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.85))),
                const SizedBox(height: 2),
                Text(fare.total, style: AppTextStyles.amountLarge.copyWith(color: AppColors.white, fontSize: 42)),
                Text(l.addedToToday,
                    style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            child: Column(
              children: [
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metric(fare.distance.replaceAll(' km', ''), l.kmUnit),
                      _divider(),
                      _metric(fare.duration.replaceAll(' min', ''), l.minUnit),
                      _divider(),
                      _metric(fare.paymentMethod, l.paymentLabel, color: AppColors.success),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const RouteIndicator(),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _routeStop(l.pickupLabel, request.pickup),
                                  const SizedBox(height: 12),
                                  _routeStop(l.dropoffLabel, request.dropoff),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 28, color: AppColors.darkBorderSoft),
                      _row(l.tripFare, fare.tripFare, AppColors.textPrimaryDark),
                      const SizedBox(height: 8),
                      _row(l.serviceFee, fare.serviceFee, AppColors.dangerSoft),
                      const SizedBox(height: 8),
                      _row(l.peakBonus, fare.peakBonus, AppColors.success),
                      const Divider(height: 24, color: AppColors.darkBorderSoft),
                      Row(
                        children: [
                          Text(l.yourEarnings,
                              style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimaryDark)),
                          const Spacer(),
                          Text(fare.total, style: AppTextStyles.amountMedium.copyWith(color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(label: l.findNextRide, onPressed: onFindNext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String value, String label, {Color color = AppColors.textPrimaryDark}) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.statValue.copyWith(color: color, fontSize: 20)),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 34, color: AppColors.darkBorderSoft);

  Widget _routeStop(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.overline.copyWith(color: AppColors.textMutedDark)),
        Text(value, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
      ],
    );
  }

  Widget _row(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
        const Spacer(),
        Text(value, style: AppTextStyles.bodyStrong.copyWith(color: valueColor)),
      ],
    );
  }
}
