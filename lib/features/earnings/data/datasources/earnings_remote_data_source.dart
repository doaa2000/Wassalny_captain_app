import '../../domain/entities/earnings_report.dart';

abstract interface class EarningsRemoteDataSource {
  Future<EarningsReport> fetchReport(EarningsPeriod period);
}

/// In-memory earnings seeded from the design (Day / Week / Month figures and
/// the weekly chart). Documents the exact data the backend must provide.
class EarningsLocalDataSource implements EarningsRemoteDataSource {
  static const List<EarningsBar> _weekChart = [
    EarningsBar(label: 'Mon', amount: 'EGP 520', ratio: 520 / 900),
    EarningsBar(label: 'Tue', amount: 'EGP 610', ratio: 610 / 900),
    EarningsBar(label: 'Wed', amount: 'EGP 470', ratio: 470 / 900),
    EarningsBar(label: 'Thu', amount: 'EGP 690', ratio: 690 / 900),
    EarningsBar(label: 'Fri', amount: 'EGP 840', ratio: 840 / 900),
    EarningsBar(label: 'Sat', amount: 'EGP 720', ratio: 720 / 900),
    EarningsBar(label: 'Sun', amount: 'EGP 642', ratio: 642 / 900, isToday: true),
  ];

  @override
  Future<EarningsReport> fetchReport(EarningsPeriod period) async {
    return switch (period) {
      EarningsPeriod.day => _report(period, 'EGP 642', '14', '6h 20m', 'EGP 46'),
      EarningsPeriod.week => _report(period, 'EGP 3,820', '78', '38h 10m', 'EGP 49'),
      EarningsPeriod.month => _report(period, 'EGP 14,560', '312', '164h', 'EGP 47'),
    };
  }

  EarningsReport _report(EarningsPeriod p, String total, String trips, String hours, String avg) {
    return EarningsReport(
      period: p,
      total: total,
      trips: trips,
      onlineHours: hours,
      averagePerTrip: avg,
      chart: _weekChart,
      bonusEarned: 'EGP 220',
      incentiveTitle: 'Weekend incentive',
      incentiveSubtitle: 'Complete 12 more trips → +EGP 180',
      incentiveProgress: 0.64,
    );
  }
}
