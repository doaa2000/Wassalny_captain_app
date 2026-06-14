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

/// Captain has arrived at the pickup; shows waiting time and "Start trip".
class ArrivedView extends StatelessWidget {
  const ArrivedView({super.key, required this.request});

  final RideRequest request;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: MapView(variant: MapVariant.route)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                ),
                child: Text(
                  "You've arrived at pickup",
                  style: AppTextStyles.bodyStrong.copyWith(color: AppColors.success, fontWeight: FontWeight.w800),
                ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.warning, size: 20),
                      const SizedBox(width: 9),
                      Text('Waiting time', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                      const Spacer(),
                      Text('2:14', style: AppTextStyles.statValue.copyWith(color: AppColors.warning)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PassengerTile(
                  request: request,
                  subtitle: 'Meeting at ${request.pickup}',
                  trailing: const [SizedBox(width: 8), CircleActionButton(icon: Icons.call_rounded, filled: true)],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Start trip',
                  variant: AppButtonVariant.success,
                  onPressed: () => context.read<TripBloc>().add(const TripStarted()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
