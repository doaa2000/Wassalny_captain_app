part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the dashboard summary and nearby requests.
class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

/// Flips the captain's online/offline availability.
class DashboardOnlineToggled extends DashboardEvent {
  const DashboardOnlineToggled();
}

/// Internal: a new set of nearby requests arrived from the Realtime stream.
class _DashboardRequestsUpdated extends DashboardEvent {
  const _DashboardRequestsUpdated(this.requests);
  final List<RideRequest> requests;

  @override
  List<Object?> get props => [requests];
}
