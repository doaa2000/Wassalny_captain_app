import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/map_view.dart';
import '../../data/services/communication_service.dart';
import '../../domain/entities/ride_request.dart';
import '../bloc/trip_bloc.dart';
import '../widgets/map_sheet.dart';
import '../widgets/passenger_tile.dart';

/// Active trip toward the destination, with ETA card and SOS.
class ActiveTripView extends StatelessWidget {
  const ActiveTripView({super.key, required this.request});

  final RideRequest request;

  Future<void> _call(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final ok = await sl<CommunicationService>().callPassenger(request.passengerPhone);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.communicationFailed)));
    }
  }

  Future<void> _message(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final ok = await sl<CommunicationService>().messagePassenger(request.passengerPhone);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.communicationFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                            Text(l.toDestination,
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
                    label: l.sos,
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
                  subtitle: l.tripTo(request.dropoff),
                  avatarSize: 52,
                  trailing: [
                    const SizedBox(width: 8),
                    CircleActionButton(
                      icon: Icons.call_rounded,
                      filled: true,
                      onPressed: () => _call(context),
                    ),
                    const SizedBox(width: 8),
                    CircleActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      onPressed: () => _message(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: l.completeTrip,
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
