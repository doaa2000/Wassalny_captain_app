import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/fare_breakdown_model.dart';
import '../models/ride_request_model.dart';
import 'trip_remote_data_source.dart';

/// Supabase-backed implementation of [TripRemoteDataSource], mapped to the
/// deployed schema (the `trips` table + the broadcast-dispatch RPCs).
///
/// This is the ONLY trip file that imports Supabase. Replacing the backend with
/// a REST API means writing a sibling implementation — no other layer changes.
class TripSupabaseDataSource implements TripRemoteDataSource {
  const TripSupabaseDataSource(this._service);

  final SupabaseService _service;

  static const String _openSelect =
      'id, pickup_address, destination_address, estimated_distance, estimated_duration, '
      'trip_price, payment_method, status, driver_id, created_at, '
      'passenger:profiles!trips_passenger_id_fkey ( full_name )';

  @override
  Future<List<RideRequestModel>> fetchNearbyRequests() async {
    try {
      final List<Map<String, dynamic>> rows = await _service.client
          .from(AppConstants.tableTrips)
          .select(_openSelect)
          .eq('status', AppConstants.tripStatusRequested)
          .isFilter('driver_id', null)
          .order('created_at', ascending: false);
      return rows.map(RideRequestModel.fromTripRow).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<RideRequestModel>> watchNearbyRequests() {
    // Realtime stream of open requests. `.stream()` supports a single eq filter,
    // so the "unassigned" check is applied client-side.
    return _service.client
        .from(AppConstants.tableTrips)
        .stream(primaryKey: ['id'])
        .eq('status', AppConstants.tripStatusRequested)
        .order('created_at')
        .map((rows) => rows
            .where((r) => r['driver_id'] == null)
            .map(RideRequestModel.fromTripRow)
            .toList());
  }

  @override
  Future<RideRequestModel> acceptRequest(String requestId) async {
    try {
      // Atomic claim: first approved driver wins (raises if already taken).
      final dynamic row = await _service.client.rpc(
        'accept_trip',
        params: {'p_trip_id': requestId},
      );
      return RideRequestModel.fromTripRow((row as Map<dynamic, dynamic>).cast<String, dynamic>());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> declineRequest(String requestId) async {
    // Broadcast model: declining simply means this driver ignores the request;
    // no server state changes (another driver can still accept it).
  }

  @override
  Future<void> markArrived(String requestId) =>
      _updateStatus(requestId, AppConstants.tripStatusArrived);

  @override
  Future<void> startTrip(String requestId) =>
      _updateStatus(requestId, AppConstants.tripStatusInProgress);

  @override
  Future<FareBreakdownModel> completeTrip(String requestId) async {
    try {
      final dynamic row = await _service.client.rpc(
        'complete_trip',
        params: {'p_trip_id': requestId},
      );
      final Map<String, dynamic> trip = (row as Map<dynamic, dynamic>).cast<String, dynamic>();
      final num? price = trip['trip_price'] as num?;
      final num? dist = trip['estimated_distance'] as num?;
      final num? dur = trip['estimated_duration'] as num?;
      return FareBreakdownModel(
        tripFare: price != null ? 'EGP ${price.toStringAsFixed(2)}' : 'EGP —',
        serviceFee: '—',
        peakBonus: '—',
        total: price != null ? 'EGP ${price.toStringAsFixed(0)}' : 'EGP —',
        distance: dist != null ? '$dist km' : '',
        duration: dur != null ? '$dur min' : '',
        paymentMethod: (trip['payment_method'] as String?) ?? 'Cash',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _updateStatus(String requestId, String status) async {
    try {
      await _service.client
          .from(AppConstants.tableTrips)
          .update({'status': status}).eq('id', requestId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
