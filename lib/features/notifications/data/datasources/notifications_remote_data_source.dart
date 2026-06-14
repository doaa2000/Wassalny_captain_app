import '../../domain/entities/app_notification.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<AppNotification>> fetchNotifications();
  Future<void> clearAll();
}

/// In-memory notifications seeded from the design.
class NotificationsLocalDataSource implements NotificationsRemoteDataSource {
  @override
  Future<List<AppNotification>> fetchNotifications() async => const [
        AppNotification(
          title: 'Payout completed',
          body: 'EGP 2,400 sent to CIB ·· 4821.',
          kind: NotificationKind.payout,
          group: NotificationGroup.today,
          unread: true,
        ),
        AppNotification(
          title: 'Weekend incentive unlocked 🎯',
          body: 'Finish 12 more trips for a +EGP 180 bonus.',
          kind: NotificationKind.incentive,
          group: NotificationGroup.today,
          unread: true,
        ),
        AppNotification(
          title: 'New 5-star rating',
          body: '"Smooth, safe ride. Thank you!" — Nadia S.',
          kind: NotificationKind.rating,
          group: NotificationGroup.earlier,
        ),
        AppNotification(
          title: 'Document reminder',
          body: 'Your insurance expires in 21 days.',
          kind: NotificationKind.document,
          group: NotificationGroup.earlier,
        ),
      ];

  @override
  Future<void> clearAll() async {}
}
