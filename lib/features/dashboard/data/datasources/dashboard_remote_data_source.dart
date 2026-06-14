import '../models/dashboard_summary_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> fetchSummary();
  Future<bool> setOnline(bool online);
}

/// In-memory implementation used without backend credentials.
class DashboardLocalDataSource implements DashboardRemoteDataSource {
  @override
  Future<DashboardSummaryModel> fetchSummary() async => const DashboardSummaryModel(
        todayEarnings: 'EGP 642',
        tripsToday: '14',
        onlineTime: '6h 20m',
      );

  @override
  Future<bool> setOnline(bool online) async => online;
}
