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
  const TripAccepted({this.offeredFare});

  /// Captain's fare when they change the passenger's price. Null keeps original.
  final double? offeredFare;

  @override
  List<Object?> get props => [offeredFare];
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

/// Internal: the trip-status subscription observed the rider cancelling
/// (status flipped to 'cancelled' on a trip this captain already accepted).
class _TripCancelledRemotely extends TripEvent {
  const _TripCancelledRemotely();
}
