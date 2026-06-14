import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/fare_breakdown_model.dart';
import '../models/ride_request_model.dart';
import 'trip_remote_data_source.dart';

/// Supabase-backed implementation of [TripRemoteDataSource].
///
/// This is the ONLY trip file that imports Supabase types. Replacing the
/// backend with a REST API means writing a sibling implementation of
/// [TripRemoteDataSource] and binding it in the DI container — no other layer
/// is touched.
class TripSupabaseDataSource implements TripRemoteDataSource {
  const TripSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<List<RideRequestModel>> fetchNearbyRequests() async {
    try {
      final List<Map<String, dynamic>> rows = await _service.client
          .from(AppConstants.tableRequests)
          .select()
          .eq('status', 'open');
      return rows.map(RideRequestModel.fromJson).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RideRequestModel> acceptRequest(String requestId) async {
    try {
      final Map<String, dynamic> row = await _service.client
          .from(AppConstants.tableRequests)
          .update({'status': 'accepted', 'captain_id': _service.currentUserId})
          .eq('id', requestId)
          .select()
          .single();
      return RideRequestModel.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> declineRequest(String requestId) =>
      _updateStatus(requestId, 'declined');

  @override
  Future<void> markArrived(String requestId) =>
      _updateStatus(requestId, 'arrived');

  @override
  Future<void> startTrip(String requestId) =>
      _updateStatus(requestId, 'in_progress');

  @override
  Future<FareBreakdownModel> completeTrip(String requestId) async {
    try {
      // A Postgres function settles the fare server-side and returns the split.
      final dynamic result = await _service.client.rpc(
        'complete_trip',
        params: {'request_id': requestId},
      );
      return FareBreakdownModel.fromJson((result as Map<dynamic, dynamic>).cast<String, dynamic>());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _updateStatus(String requestId, String status) async {
    try {
      await _service.client
          .from(AppConstants.tableRequests)
          .update({'status': status}).eq('id', requestId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
