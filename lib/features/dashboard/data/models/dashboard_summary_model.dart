import '../../domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.todayEarnings,
    required super.tripsToday,
    required super.onlineTime,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      todayEarnings: json['today_earnings'] as String? ?? 'EGP 0',
      tripsToday: json['trips_today']?.toString() ?? '0',
      onlineTime: json['online_time'] as String? ?? '0h',
    );
  }
}
