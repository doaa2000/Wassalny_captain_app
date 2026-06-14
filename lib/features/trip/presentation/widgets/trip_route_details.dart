import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/route_indicator.dart';

/// Two-stop pickup → drop-off detail block with optional distance labels.
class TripRouteDetails extends StatelessWidget {
  const TripRouteDetails({
    super.key,
    required this.pickup,
    required this.dropoff,
    this.pickupLabel,
    this.dropoffLabel,
  });

  final String pickup;
  final String dropoff;
  final String? pickupLabel;
  final String? dropoffLabel;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RouteIndicator(dotSize: 11),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _stop(pickupLabel ?? 'PICKUP', pickup),
                const SizedBox(height: 12),
                _stop(dropoffLabel ?? 'DROP-OFF', dropoff),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stop(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.overline.copyWith(color: AppColors.textMutedDark, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
      ],
    );
  }
}
