import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/map_view.dart';
import '../../domain/entities/ride_request.dart';
import '../bloc/trip_bloc.dart';
import '../widgets/map_sheet.dart';
import '../widgets/passenger_tile.dart';

/// Turn-by-turn style banner guiding the captain to the pickup point.
class NavigateToPickupView extends StatelessWidget {
  const NavigateToPickupView({super.key, required this.request});

  final RideRequest request;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Stack(
      children: [
        const Positioned.fill(child: MapView(variant: MapVariant.route)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: AppCard(
              color: AppColors.darkSurface,
              borderColor: AppColors.darkBorder,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.navigation_rounded, color: AppColors.primary, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.headToPickup, style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimaryDark)),
                        Text(
                          l.pickupWithDistance(request.pickupDistance, request.pickup),
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('${request.pickupEtaMinutes}',
                          style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary)),
                      Text(l.min, style: AppTextStyles.micro.copyWith(color: AppColors.textMutedDark)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MapSheet(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PassengerTile(
                  request: request,
                  subtitle: '${request.passengerRating} · ${request.fare} · ${request.paymentMethod}',
                  trailing: const [
                    SizedBox(width: 8),
                    CircleActionButton(icon: Icons.call_rounded, filled: true),
                    SizedBox(width: 8),
                    CircleActionButton(icon: Icons.chat_bubble_outline_rounded),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: l.iveArrivedAtPickup,
                  onPressed: () => context.read<TripBloc>().add(const TripArrivedAtPickup()),
                ),
                const SizedBox(height: 9),
                AppButton(
                  label: l.cancelTrip,
                  variant: AppButtonVariant.ghost,
                  height: 44,
                  onPressed: () => context.read<TripBloc>().add(const TripDeclined()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
