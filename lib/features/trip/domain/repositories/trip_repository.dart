import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/fare_breakdown.dart';
import '../entities/ride_request.dart';

/// Domain contract for trip & ride-request operations. The presentation and
/// domain layers depend only on this interface, never on Supabase.
abstract interface class TripRepository {
  /// Ride requests currently available near the captain.
  Future<Either<Failure, List<RideRequest>>> getNearbyRequests();

  /// Live stream of available ride requests (Realtime broadcast dispatch).
  Stream<List<RideRequest>> watchNearbyRequests();

  /// Accept a request and start heading to the pickup.
  /// [offeredFare] overrides the passenger's price when the captain counters.
  Future<Either<Failure, RideRequest>> acceptRequest(
    String requestId, {
    double? offeredFare,
  });

  /// Decline / let a request expire.
  Future<Either<Failure, Unit>> declineRequest(String requestId);

  /// Mark the captain as arrived at the pickup point.
  Future<Either<Failure, Unit>> markArrived(String requestId);

  /// Begin the active trip toward the drop-off.
  Future<Either<Failure, Unit>> startTrip(String requestId);

  /// Complete the trip and settle the fare.
  Future<Either<Failure, FareBreakdown>> completeTrip(String requestId);

  /// Live status of an already-accepted trip — the only way the app learns
  /// the rider cancelled before the trip reached `in_progress`.
  Stream<String> watchTripStatus(String tripId);
}
