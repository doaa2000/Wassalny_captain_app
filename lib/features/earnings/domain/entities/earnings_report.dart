import 'package:equatable/equatable.dart';

/// One selectable reporting period (Day / Week / Month).
enum EarningsPeriod { day, week, month }

/// A single bar in the weekly earnings chart.
class EarningsBar extends Equatable {
  const EarningsBar({required this.label, required this.amount, required this.ratio, this.isToday = false});

  final String label;
  final String amount;

  /// 0..1 height ratio relative to the chart's max.
  final double ratio;
  final bool isToday;

  @override
  List<Object?> get props => [label, amount, ratio, isToday];
}

/// Aggregated earnings for a period plus supporting widgets' data.
class EarningsReport extends Equatable {
  const EarningsReport({
    required this.period,
    required this.total,
    required this.trips,
    required this.onlineHours,
    required this.averagePerTrip,
    required this.chart,
    required this.bonusEarned,
    required this.incentiveTitle,
    required this.incentiveSubtitle,
    required this.incentiveProgress,
  });

  final EarningsPeriod period;
  final String total;
  final String trips;
  final String onlineHours;
  final String averagePerTrip;
  final List<EarningsBar> chart;
  final String bonusEarned;
  final String incentiveTitle;
  final String incentiveSubtitle;
  final double incentiveProgress;

  @override
  List<Object?> get props => [period, total, trips, onlineHours, averagePerTrip];
}
