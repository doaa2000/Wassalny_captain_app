part of 'trip_bloc.dart';

/// Lifecycle phase the captain is currently in.
enum TripPhase { idle, incoming, expired, navigateToPickup, arrived, inProgress, completed }

enum TripStatus { idle, processing, failure }

class TripState extends Equatable {
  const TripState({
    this.phase = TripPhase.idle,
    this.status = TripStatus.idle,
    this.request,
    this.countdown = 0,
    this.fareBreakdown,
    this.errorMessage,
  });

  final TripPhase phase;
  final TripStatus status;
  final RideRequest? request;
  final int countdown;
  final FareBreakdown? fareBreakdown;
  final String? errorMessage;

  TripState copyWith({
    TripPhase? phase,
    TripStatus? status,
    RideRequest? request,
    int? countdown,
    FareBreakdown? fareBreakdown,
    String? errorMessage,
  }) {
    return TripState(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      request: request ?? this.request,
      countdown: countdown ?? this.countdown,
      fareBreakdown: fareBreakdown ?? this.fareBreakdown,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [phase, status, request, countdown, fareBreakdown, errorMessage];
}
