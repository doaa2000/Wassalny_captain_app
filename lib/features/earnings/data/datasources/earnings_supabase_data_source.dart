import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/earnings_report.dart';
import 'earnings_remote_data_source.dart';

class EarningsSupabaseDataSource implements EarningsRemoteDataSource {
  const EarningsSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<EarningsReport> fetchReport(EarningsPeriod period) async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final now = DateTime.now();
      final start = _periodStart(now, period);

      final List<Map<String, dynamic>> rows = await _service.client
          .from(AppConstants.tableTrips)
          .select('trip_price, completed_at')
          .eq('driver_id', userId)
          .eq('status', AppConstants.tripStatusCompleted)
          .gte('completed_at', start.toIso8601String())
          .order('completed_at');

      final num total =
          rows.fold<num>(0, (s, r) => s + ((r['trip_price'] as num?) ?? 0));
      final int count = rows.length;
      final num avg = count > 0 ? total / count : 0;

      final chart = await _weeklyChart(userId, now);

      final String totalStr =
          'EGP ${total.toStringAsFixed(total >= 1000 ? 0 : 2)}';
      final String tripsStr = count.toString();
      final String avgStr = 'EGP ${avg.toStringAsFixed(0)}';

      return switch (period) {
        EarningsPeriod.day => EarningsReport(
            period: period,
            total: totalStr,
            trips: tripsStr,
            onlineHours: '—',
            averagePerTrip: avgStr,
            chart: chart,
            bonusEarned: 'EGP 0',
            incentiveTitle: 'Weekend incentive',
            incentiveSubtitle: 'Complete 12 more trips → +EGP 180',
            incentiveProgress: 0,
          ),
        EarningsPeriod.week => EarningsReport(
            period: period,
            total: totalStr,
            trips: tripsStr,
            onlineHours: '—',
            averagePerTrip: avgStr,
            chart: chart,
            bonusEarned: 'EGP 0',
            incentiveTitle: 'Weekend incentive',
            incentiveSubtitle: 'Complete 12 more trips → +EGP 180',
            incentiveProgress: 0,
          ),
        EarningsPeriod.month => EarningsReport(
            period: period,
            total: totalStr,
            trips: tripsStr,
            onlineHours: '—',
            averagePerTrip: avgStr,
            chart: chart,
            bonusEarned: 'EGP 0',
            incentiveTitle: 'Weekend incentive',
            incentiveSubtitle: 'Complete 12 more trips → +EGP 180',
            incentiveProgress: 0,
          ),
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  DateTime _periodStart(DateTime now, EarningsPeriod period) => switch (period) {
        EarningsPeriod.day => DateTime(now.year, now.month, now.day),
        EarningsPeriod.week => now.subtract(Duration(days: now.weekday - 1)),
        EarningsPeriod.month => DateTime(now.year, now.month, 1),
      };

  Future<List<EarningsBar>> _weeklyChart(String userId, DateTime now) async {
    final weekStart =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));

    final List<Map<String, dynamic>> rows = await _service.client
        .from(AppConstants.tableTrips)
        .select('trip_price, completed_at')
        .eq('driver_id', userId)
        .eq('status', AppConstants.tripStatusCompleted)
        .gte('completed_at', weekStart.toIso8601String())
        .order('completed_at');

    final Map<int, num> daily = {};
    for (final r in rows) {
      final dt = DateTime.parse(r['completed_at'] as String);
      final idx = dt.difference(weekStart).inDays.clamp(0, 6);
      daily[idx] = (daily[idx] ?? 0) + ((r['trip_price'] as num?) ?? 0);
    }

    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal =
        daily.values.isEmpty ? 1 : daily.values.reduce((a, b) => a > b ? a : b);

    return List.generate(7, (i) {
      final v = daily[i] ?? 0;
      final String amount = 'EGP ${v.toStringAsFixed(0)}';
      return EarningsBar(
        label: labels[i],
        amount: amount,
        ratio: maxVal > 0 ? v.toDouble() / maxVal.toDouble() : 0,
        isToday: i == now.weekday - 1,
      );
    });
  }
}
