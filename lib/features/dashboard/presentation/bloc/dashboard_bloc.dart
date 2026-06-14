import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../trip/domain/entities/ride_request.dart';
import '../../../trip/domain/usecases/get_nearby_requests.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import '../../domain/usecases/set_online_status.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// Drives the dashboard: loads stats + nearby requests and manages the
/// online/offline toggle. Reuses the trip feature's [GetNearbyRequests] use
/// case so request fetching has a single source of truth.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetDashboardSummary getSummary,
    required SetOnlineStatus setOnline,
    required GetNearbyRequests getNearbyRequests,
  })  : _getSummary = getSummary,
        _setOnline = setOnline,
        _getNearbyRequests = getNearbyRequests,
        super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardOnlineToggled>(_onToggled);
  }

  final GetDashboardSummary _getSummary;
  final SetOnlineStatus _setOnline;
  final GetNearbyRequests _getNearbyRequests;

  Future<void> _onStarted(DashboardStarted event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final summaryResult = await _getSummary(const NoParams());
    final requestsResult = await _getNearbyRequests(const NoParams());

    final DashboardSummary? summary = summaryResult.fold((_) => null, (s) => s);
    final List<RideRequest> requests = requestsResult.fold((_) => const [], (r) => r);

    if (summary == null) {
      emit(state.copyWith(status: DashboardStatus.failure, errorMessage: 'Could not load your dashboard.'));
      return;
    }
    emit(state.copyWith(status: DashboardStatus.ready, summary: summary, requests: requests));
  }

  Future<void> _onToggled(DashboardOnlineToggled event, Emitter<DashboardState> emit) async {
    final bool target = !state.online;
    // Optimistic update for instant UI feedback.
    emit(state.copyWith(online: target));
    final result = await _setOnline(target);
    result.fold(
      (_) => emit(state.copyWith(online: !target)), // revert on failure
      (confirmed) => emit(state.copyWith(online: confirmed)),
    );
  }
}
