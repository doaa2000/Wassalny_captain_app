import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/trip_bloc.dart';
import '../views/active_trip_view.dart';
import '../views/arrived_view.dart';
import '../views/incoming_request_view.dart';
import '../views/navigate_to_pickup_view.dart';
import '../views/trip_completed_view.dart';

/// Hosts the entire trip lifecycle as a single route. The visible "screen" is
/// derived from [TripState.phase] — faithfully mirroring the source design,
/// which swaps screens via state rather than navigation. Terminal phases route
/// back to the dashboard through the centralized router.
class TripFlowPage extends StatelessWidget {
  const TripFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocConsumer<TripBloc, TripState>(
        listenWhen: (prev, curr) => prev.phase != curr.phase,
        listener: (context, state) {
          if (state.phase == TripPhase.expired || state.phase == TripPhase.idle) {
            context.go(AppRoutes.dashboard);
          }
        },
        builder: (context, state) {
          final request = state.request;
          if (request == null) {
            return const SizedBox.shrink();
          }

          final Widget child = switch (state.phase) {
            TripPhase.incoming ||
            TripPhase.expired =>
              IncomingRequestView(request: request, countdown: state.countdown),
            TripPhase.navigateToPickup => NavigateToPickupView(request: request),
            TripPhase.arrived => ArrivedView(request: request),
            TripPhase.inProgress => ActiveTripView(request: request),
            TripPhase.completed => TripCompletedView(
                request: request,
                fare: state.fareBreakdown!,
                onFindNext: () {
                  context.read<TripBloc>().add(const TripReset());
                },
              ),
            TripPhase.idle => const SizedBox.shrink(),
          };

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(key: ValueKey(state.phase), child: child),
          );
        },
      ),
    );
  }
}
