part of 'trip_bloc.dart';

/// Events driving the trip lifecycle state machine.
sealed class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

/// An incoming request was opened; starts the acceptance countdown.
class TripRequestOpened extends TripEvent {
  const TripRequestOpened(this.request);
  final RideRequest request;

  @override
  List<Object?> get props => [request];
}

/// Internal: one second elapsed on the acceptance countdown.
class _TripCountdownTicked extends TripEvent {
  const _TripCountdownTicked(this.remaining);
  final int remaining;

  @override
  List<Object?> get props => [remaining];
}

class TripAccepted extends TripEvent {
  const TripAccepted();
}

class TripDeclined extends TripEvent {
  const TripDeclined();
}

class TripArrivedAtPickup extends TripEvent {
  const TripArrivedAtPickup();
}

class TripStarted extends TripEvent {
  const TripStarted();
}

class TripCompletedRequested extends TripEvent {
  const TripCompletedRequested();
}

class TripReset extends TripEvent {
  const TripReset();
}
