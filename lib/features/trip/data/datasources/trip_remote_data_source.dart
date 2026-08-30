import '../models/fare_breakdown_model.dart';
import '../models/ride_request_model.dart';

/// Remote data source contract for trips. Repository implementations depend on
/// this abstraction, so the concrete backend (Supabase today, REST tomorrow)
/// can be swapped by providing a different implementation — nothing in the
/// domain or presentation layers changes.
abstract interface class TripRemoteDataSource {
  Future<List<RideRequestModel>> fetchNearbyRequests();

  /// Live stream of open ride requests (Realtime). Emits the current set of
  /// `requested` trips and updates whenever one is added/changed.
  Stream<List<RideRequestModel>> watchNearbyRequests();

  Future<RideRequestModel> acceptRequest(String requestId);
  Future<void> declineRequest(String requestId);
  Future<void> markArrived(String requestId);
  Future<void> startTrip(String requestId);
  Future<FareBreakdownModel> completeTrip(String requestId);

  /// Live stream of a single trip's status after this driver has accepted
  /// it — the only way the app finds out if the rider cancels mid-flow
  /// (before the trip reaches `in_progress`), since nothing else watches an
  /// already-accepted trip for external changes.
  Stream<String> watchTripStatus(String tripId);
}
