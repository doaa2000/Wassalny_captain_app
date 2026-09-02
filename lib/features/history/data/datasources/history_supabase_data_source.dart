import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/trip_history_item.dart';
import 'history_remote_data_source.dart';

class HistorySupabaseDataSource implements HistoryRemoteDataSource {
  const HistorySupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<List<TripHistoryItem>> fetchHistory() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final List<Map<String, dynamic>> rows = await _service.client
          .from(AppConstants.tableTrips)
          .select(
            'id, pickup_address, destination_address, estimated_distance, '
            'estimated_duration, trip_price, completed_at, passenger_id, '
            'passenger:profiles!trips_passenger_id_fkey ( full_name )',
          )
          .eq('driver_id', userId)
          .eq('status', AppConstants.tripStatusCompleted)
          .order('completed_at', ascending: false)
          .limit(50);

      if (rows.isEmpty) return const [];

      final tripIds = rows.map((r) => r['id'] as String).toList();
      final List<Map<String, dynamic>> ratingsRows = await _service.client
          .from(AppConstants.tableRatings)
          .select('trip_id, rating')
          .inFilter('trip_id', tripIds);

      final Map<String, num> ratingsMap = {
        for (final r in ratingsRows)
          r['trip_id'] as String: (r['rating'] as num?) ?? 0,
      };

      return rows.map((r) {
        final passenger = r['passenger'] as Map<String, dynamic>?;
        final String name = (passenger?['full_name'] as String?) ?? 'Passenger';
        final String initials = _initials(name);
        final DateTime? completedAt = r['completed_at'] != null
            ? DateTime.tryParse(r['completed_at'] as String)
            : null;
        final String time =
            completedAt != null ? _formatTimestamp(completedAt) : '';
        final num? price = r['trip_price'] as num?;
        final num? dist = r['estimated_distance'] as num?;
        final num? dur = r['estimated_duration'] as num?;
        final num rating = ratingsMap[r['id'] as String] ?? 0;

        return TripHistoryItem(
          time: time,
          earnings: price != null ? 'EGP ${price.toStringAsFixed(0)}' : 'EGP —',
          from: (r['pickup_address'] as String?) ?? '',
          to: (r['destination_address'] as String?) ?? '',
          distance: dist != null ? '$dist km' : '',
          duration: dur != null ? '$dur min' : '',
          passengerName: name,
          passengerInitials: initials,
          rating: rating > 0 ? rating.toStringAsFixed(1) : '—',
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final time = DateFormat('HH:mm').format(dt);

    if (date == today) return 'Today · $time';
    if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday · $time';
    }
    return DateFormat('MMM d · HH:mm').format(dt);
  }
}
