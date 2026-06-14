import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/map_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/ride_request.dart';
import '../bloc/trip_bloc.dart';
import '../widgets/map_sheet.dart';
import '../widgets/passenger_tile.dart';
import '../widgets/trip_route_details.dart';

/// Incoming ride request with the acceptance countdown ring.
class IncomingRequestView extends StatelessWidget {
  const IncomingRequestView({super.key, required this.request, required this.countdown});

  final RideRequest request;
  final int countdown;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: MapView(variant: MapVariant.route)),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66080C10), Color(0x1A080C10), Color(0xD9080C10)],
                stops: [0, 0.4, 1],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Align(
              alignment: Alignment.topCenter,
              child: _CountdownRing(countdown: countdown),
            ),
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _RequestSheet(request: request)),
      ],
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({required this.countdown});

  final int countdown;

  @override
  Widget build(BuildContext context) {
    final double total = AppConstants.requestCountdown.inSeconds.toDouble();
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: countdown / total, end: countdown / total),
              duration: const Duration(milliseconds: 950),
              builder: (_, value, __) => CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                color: AppColors.primary,
                backgroundColor: AppColors.darkBorder,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$countdown', style: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark, fontSize: 30)),
              Text('SECONDS', style: AppTextStyles.micro.copyWith(color: AppColors.textMutedDark, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestSheet extends StatelessWidget {
  const _RequestSheet({required this.request});

  final RideRequest request;

  @override
  Widget build(BuildContext context) {
    return MapSheet(
      showHandle: false,
      borderColor: const Color(0xFF2A6B8A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusBadge(label: request.tier, color: AppColors.primary),
              const SizedBox(width: 9),
              Text(
                '${request.pickupEtaMinutes} min · ${request.pickupDistance}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
              ),
              const Spacer(),
              Text(request.fare, style: AppTextStyles.title.copyWith(color: AppColors.success, fontSize: 24)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: PassengerTile(request: request, avatarSize: 46),
          ),
          const SizedBox(height: 14),
          TripRouteDetails(
            pickup: request.pickup,
            dropoff: request.dropoff,
            pickupLabel: 'PICKUP · ${request.pickupDistance}',
            dropoffLabel: 'DROP-OFF · ${request.distance}',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 96,
                child: AppButton(
                  label: 'Decline',
                  variant: AppButtonVariant.outlined,
                  expand: false,
                  height: 58,
                  onPressed: () => context.read<TripBloc>().add(const TripDeclined()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Accept · ${request.fare}',
                  onPressed: () => context.read<TripBloc>().add(const TripAccepted()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
