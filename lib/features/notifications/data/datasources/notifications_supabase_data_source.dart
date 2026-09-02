import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/app_notification.dart';
import 'notifications_remote_data_source.dart';

class NotificationsSupabaseDataSource implements NotificationsRemoteDataSource {
  const NotificationsSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final List<Map<String, dynamic>> rows = await _service.client
          .from(AppConstants.tableNotifications)
          .select('title, body, type, is_read, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return rows.map((r) {
        final DateTime? createdAt = r['created_at'] != null
            ? DateTime.tryParse(r['created_at'] as String)
            : null;
        final bool isToday =
            createdAt != null && !createdAt.isBefore(today);
        final String type = (r['type'] as String?) ?? 'system';

        return AppNotification(
          title: (r['title'] as String?) ?? '',
          body: (r['body'] as String?) ?? '',
          kind: _mapKind(type),
          group: isToday ? NotificationGroup.today : NotificationGroup.earlier,
          unread: (r['is_read'] as bool?) != true,
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      await _service.client
          .from(AppConstants.tableNotifications)
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  NotificationKind _mapKind(String type) => switch (type) {
        'payment' => NotificationKind.payout,
        'promo' => NotificationKind.incentive,
        'trip_completed' => NotificationKind.rating,
        'document_verified' => NotificationKind.document,
        _ => NotificationKind.payout,
      };
}
