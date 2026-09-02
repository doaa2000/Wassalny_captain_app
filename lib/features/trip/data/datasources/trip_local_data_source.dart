import '../models/fare_breakdown_model.dart';
import '../models/ride_request_model.dart';
import 'trip_remote_data_source.dart';

/// In-memory implementation of [TripRemoteDataSource].
///
/// Used when no Supabase credentials are configured so the full UI is runnable
/// offline. It also documents the exact shape the real backend must return.
/// Seeded with the data from the source design.
class TripLocalDataSource implements TripRemoteDataSource {
  static const List<RideRequestModel> _seed = [
    RideRequestModel(
      id: '0',
      tier: 'Go',
      pickup: 'Tahrir Square',
      dropoff: 'Cairo Festival City',
      distance: '14.2 km',
      duration: '24 min',
      fare: 'EGP 96',
      fareAmount: 96,
      pickupEtaMinutes: 4,
      pickupDistance: '2.1 km',
      passengerName: 'Nadia Saleh',
      passengerPhone: '+20 100 123 4567',
      passengerInitials: 'NS',
      passengerRating: '4.8',
      paymentMethod: 'Wallet',
    ),
    RideRequestModel(
      id: '1',
      tier: 'Comfort',
      pickup: 'Zamalek, 26 July St',
      dropoff: 'New Cairo, 5th Settlement',
      distance: '18.6 km',
      duration: '32 min',
      fare: 'EGP 148',
      fareAmount: 148,
      pickupEtaMinutes: 6,
      pickupDistance: '3.0 km',
      passengerName: 'Omar Adel',
      passengerPhone: '+20 101 987 6543',
      passengerInitials: 'OA',
      passengerRating: '4.9',
      paymentMethod: 'Cash',
    ),
  ];

  @override
  Future<List<RideRequestModel>> fetchNearbyRequests() async => _seed;

  @override
  Stream<List<RideRequestModel>> watchNearbyRequests() =>
      Stream<List<RideRequestModel>>.value(_seed);

  @override
  Future<RideRequestModel> acceptRequest(String requestId, {double? offeredFare}) async {
    final RideRequestModel accepted =
        _seed.firstWhere((r) => r.id == requestId, orElse: () => _seed.first);
    if (offeredFare == null) return accepted;
    return accepted.copyWith(
      fare: 'EGP ${offeredFare.toStringAsFixed(0)}',
      fareAmount: offeredFare,
    );
  }

  @override
  Future<void> declineRequest(String requestId) async {}

  @override
  Future<void> markArrived(String requestId) async {}

  @override
  Future<void> startTrip(String requestId) async {}

  @override
  Future<FareBreakdownModel> completeTrip(String requestId) async {
    final RideRequestModel req =
        _seed.firstWhere((r) => r.id == requestId, orElse: () => _seed.first);
    return FareBreakdownModel(
      tripFare: 'EGP 88.00',
      serviceFee: '– EGP 7.04',
      peakBonus: '+ EGP 15.00',
      total: req.fare,
      distance: req.distance,
      duration: req.duration,
      paymentMethod: req.paymentMethod,
    );
  }

  @override
  Stream<String> watchTripStatus(String tripId) => const Stream<String>.empty();
}
