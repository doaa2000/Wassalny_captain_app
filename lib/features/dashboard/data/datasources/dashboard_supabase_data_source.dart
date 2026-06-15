import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/dashboard_summary_model.dart';
import 'dashboard_remote_data_source.dart';

/// Supabase-backed dashboard data, mapped to the deployed schema:
/// the daily summary comes from the `captain_today_summary()` RPC and the
/// availability toggle updates `drivers.online_status`.
class DashboardSupabaseDataSource implements DashboardRemoteDataSource {
  const DashboardSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<DashboardSummaryModel> fetchSummary() async {
    try {
      final dynamic row = await _service.client.rpc('captain_today_summary');
      return DashboardSummaryModel.fromJson(
        (row as Map<dynamic, dynamic>).cast<String, dynamic>(),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setOnline(bool online) async {
    try {
      await _service.client.from(AppConstants.tableDrivers).update({
        'online_status': online ? 'online' : 'offline',
      }).eq('profile_id', _service.currentUserId ?? '');
      return online;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
