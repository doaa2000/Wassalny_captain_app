import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/map_view.dart';
import '../../domain/entities/ride_request.dart';
import '../bloc/trip_bloc.dart';
import '../widgets/map_sheet.dart';
import '../widgets/passenger_tile.dart';

/// Active trip toward the destination, with ETA card and SOS.
class ActiveTripView extends StatelessWidget {
  const ActiveTripView({super.key, required this.request});

  final RideRequest request;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: MapView(variant: MapVariant.tracking)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To destination',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
                            Text('11 min · 6.4 km',
                                style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimaryDark)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.navigation_rounded, color: AppColors.primary, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 54,
                  height: 54,
                  child: AppButton(
                    label: 'SOS',
                    variant: AppButtonVariant.danger,
                    height: 54,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MapSheet(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: _progressBar(1)),
                    const SizedBox(width: 8),
                    Expanded(child: _progressBar(0.6)),
                    const SizedBox(width: 8),
                    Expanded(child: _progressBar(0)),
                  ],
                ),
                const SizedBox(height: 14),
                PassengerTile(
                  request: request,
                  subtitle: 'Trip to ${request.dropoff}',
                  avatarSize: 52,
                  trailing: const [SizedBox(width: 8), CircleActionButton(icon: Icons.call_rounded, filled: true)],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Complete trip',
                  onPressed: () => context.read<TripBloc>().add(const TripCompletedRequested()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressBar(double fill) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 6,
        child: LinearProgressIndicator(
          value: fill,
          backgroundColor: AppColors.darkTrack,
          color: AppColors.success,
        ),
      ),
    );
  }
}
