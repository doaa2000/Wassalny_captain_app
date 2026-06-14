import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/dashboard_summary_model.dart';
import 'dashboard_remote_data_source.dart';

/// Supabase-backed dashboard data. Isolated from domain/presentation.
class DashboardSupabaseDataSource implements DashboardRemoteDataSource {
  const DashboardSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<DashboardSummaryModel> fetchSummary() async {
    try {
      final Map<String, dynamic> row = await _service.client
          .from(AppConstants.tableEarnings)
          .select('today_earnings, trips_today, online_time')
          .eq('captain_id', _service.currentUserId ?? '')
          .single();
      return DashboardSummaryModel.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setOnline(bool online) async {
    try {
      await _service.client
          .from(AppConstants.tableCaptains)
          .update({'is_online': online}).eq('id', _service.currentUserId ?? '');
      return online;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
