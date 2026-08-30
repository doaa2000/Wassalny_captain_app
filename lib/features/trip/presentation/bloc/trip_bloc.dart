import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/fare_breakdown.dart';
import '../../domain/entities/ride_request.dart';
import '../../domain/usecases/accept_request.dart';
import '../../domain/usecases/complete_trip.dart';
import '../../domain/repositories/trip_repository.dart';

part 'trip_event.dart';
part 'trip_state.dart';

/// Owns the entire trip lifecycle: incoming request → pickup → arrived →
/// in-progress → completed. All business logic (calling use cases, running the
/// acceptance countdown) lives here; the trip pages are purely declarative.
class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc({
    required AcceptRequest acceptRequest,
    required CompleteTrip completeTrip,
    required TripRepository repository,
  })  : _acceptRequest = acceptRequest,
        _completeTrip = completeTrip,
        _repository = repository,
        super(const TripState()) {
    on<TripRequestOpened>(_onRequestOpened);
    on<_TripCountdownTicked>(_onCountdownTicked);
    on<TripAccepted>(_onAccepted);
    on<TripDeclined>(_onDeclined);
    on<TripArrivedAtPickup>(_onArrived);
    on<TripStarted>(_onStarted);
    on<TripCompletedRequested>(_onCompleted);
    on<TripReset>(_onReset);
    on<_TripCancelledRemotely>(_onCancelledRemotely);
  }

  final AcceptRequest _acceptRequest;
  final CompleteTrip _completeTrip;
  final TripRepository _repository;

  Timer? _countdownTimer;
  StreamSubscription<String>? _statusSub;

  void _onRequestOpened(TripRequestOpened event, Emitter<TripState> emit) {
    final int seconds = AppConstants.requestCountdown.inSeconds;
    emit(state.copyWith(
      phase: TripPhase.incoming,
      request: event.request,
      countdown: seconds,
      status: TripStatus.idle,
    ));
    _startCountdown(seconds);
  }

  void _startCountdown(int from) {
    _countdownTimer?.cancel();
    int remaining = from;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      remaining -= 1;
      add(_TripCountdownTicked(remaining));
    });
  }

  void _onCountdownTicked(_TripCountdownTicked event, Emitter<TripState> emit) {
    if (state.phase != TripPhase.incoming) return;
    if (event.remaining <= 0) {
      _countdownTimer?.cancel();
      emit(state.copyWith(phase: TripPhase.expired, countdown: 0));
      return;
    }
    emit(state.copyWith(countdown: event.remaining));
  }

  Future<void> _onAccepted(TripAccepted event, Emitter<TripState> emit) async {
    _countdownTimer?.cancel();
    final RideRequest? request = state.request;
    if (request == null) return;

    emit(state.copyWith(status: TripStatus.processing));
    final result = await _acceptRequest(request.id);
    result.fold(
      (failure) => emit(state.copyWith(status: TripStatus.failure, errorMessage: failure.message)),
      (accepted) {
        emit(state.copyWith(
          phase: TripPhase.navigateToPickup,
          status: TripStatus.idle,
          request: accepted,
        ));
        _watchForCancellation(accepted.id);
      },
    );
  }

  /// Watches the accepted trip's status live — the rider's cancel button
  /// updates this same row directly, and nothing else tells this app about
  /// it otherwise. Stopped once the trip is past the cancellable window
  /// (arrived/in-progress) or the flow ends.
  void _watchForCancellation(String tripId) {
    _statusSub?.cancel();
    _statusSub = _repository.watchTripStatus(tripId).listen((status) {
      if (status == 'cancelled') add(const _TripCancelledRemotely());
    });
  }

  void _onCancelledRemotely(
      _TripCancelledRemotely event, Emitter<TripState> emit) {
    _statusSub?.cancel();
    _statusSub = null;
    emit(state.copyWith(phase: TripPhase.cancelledByRider, status: TripStatus.idle));
  }

  Future<void> _onDeclined(TripDeclined event, Emitter<TripState> emit) async {
    _countdownTimer?.cancel();
    final RideRequest? request = state.request;
    if (request != null) {
      await _repository.declineRequest(request.id);
    }
    emit(const TripState());
  }

  Future<void> _onArrived(TripArrivedAtPickup event, Emitter<TripState> emit) async {
    final RideRequest? request = state.request;
    if (request != null) await _repository.markArrived(request.id);
    // Still watching — the rider can cancel through 'arrived' too, only
    // 'in_progress' and later are no longer cancellable.
    emit(state.copyWith(phase: TripPhase.arrived));
  }

  Future<void> _onStarted(TripStarted event, Emitter<TripState> emit) async {
    final RideRequest? request = state.request;
    if (request != null) await _repository.startTrip(request.id);
    _statusSub?.cancel();
    _statusSub = null;
    emit(state.copyWith(phase: TripPhase.inProgress));
  }

  Future<void> _onCompleted(TripCompletedRequested event, Emitter<TripState> emit) async {
    final RideRequest? request = state.request;
    if (request == null) return;

    emit(state.copyWith(status: TripStatus.processing));
    final result = await _completeTrip(request.id);
    result.fold(
      (failure) => emit(state.copyWith(status: TripStatus.failure, errorMessage: failure.message)),
      (breakdown) => emit(state.copyWith(
        phase: TripPhase.completed,
        status: TripStatus.idle,
        fareBreakdown: breakdown,
      )),
    );
  }

  void _onReset(TripReset event, Emitter<TripState> emit) {
    _countdownTimer?.cancel();
    _statusSub?.cancel();
    _statusSub = null;
    emit(const TripState());
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _statusSub?.cancel();
    return super.close();
  }
}
