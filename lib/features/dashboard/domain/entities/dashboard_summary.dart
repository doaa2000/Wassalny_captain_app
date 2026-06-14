import 'package:equatable/equatable.dart';

/// The captain's at-a-glance stats shown on the dashboard pills.
class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.todayEarnings,
    required this.tripsToday,
    required this.onlineTime,
  });

  final String todayEarnings;
  final String tripsToday;
  final String onlineTime;

  @override
  List<Object?> get props => [todayEarnings, tripsToday, onlineTime];
}
