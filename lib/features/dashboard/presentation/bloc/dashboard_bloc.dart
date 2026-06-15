import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../trip/domain/entities/ride_request.dart';
import '../../../trip/domain/usecases/get_nearby_requests.dart';
import '../../../trip/domain/usecases/watch_nearby_requests.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import '../../domain/usecases/set_online_status.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// Drives the dashboard: loads stats, manages the online/offline toggle, and
/// subscribes to the Realtime stream of nearby requests (broadcast dispatch).
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetDashboardSummary getSummary,
    required SetOnlineStatus setOnline,
    required GetNearbyRequests getNearbyRequests,
    required WatchNearbyRequests watchNearbyRequests,
  })  : _getSummary = getSummary,
        _setOnline = setOnline,
        _getNearbyRequests = getNearbyRequests,
        _watchNearbyRequests = watchNearbyRequests,
        super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardOnlineToggled>(_onToggled);
    on<_DashboardRequestsUpdated>(_onRequestsUpdated);
  }

  final GetDashboardSummary _getSummary;
  final SetOnlineStatus _setOnline;
  final GetNearbyRequests _getNearbyRequests;
  final WatchNearbyRequests _watchNearbyRequests;

  StreamSubscription<List<RideRequest>>? _requestsSub;

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

    // Subscribe to live request updates (no-op-safe in mock mode).
    _requestsSub?.cancel();
    _requestsSub = _watchNearbyRequests().listen(
      (reqs) => add(_DashboardRequestsUpdated(reqs)),
      onError: (_) {},
    );
  }

  void _onRequestsUpdated(_DashboardRequestsUpdated event, Emitter<DashboardState> emit) {
    if (state.status != DashboardStatus.ready) return;
    emit(state.copyWith(requests: event.requests));
  }

  Future<void> _onToggled(DashboardOnlineToggled event, Emitter<DashboardState> emit) async {
    final bool target = !state.online;
    emit(state.copyWith(online: target)); // optimistic
    final result = await _setOnline(target);
    result.fold(
      (_) => emit(state.copyWith(online: !target)), // revert on failure
      (confirmed) => emit(state.copyWith(online: confirmed)),
    );
  }

  @override
  Future<void> close() {
    _requestsSub?.cancel();
    return super.close();
  }
}
