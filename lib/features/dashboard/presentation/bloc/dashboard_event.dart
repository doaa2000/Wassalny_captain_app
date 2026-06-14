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
