import 'package:equatable/equatable.dart';

enum NotificationKind { payout, incentive, rating, document }

/// Whether the notification belongs to the "Today" or "Earlier" section.
enum NotificationGroup { today, earlier }

class AppNotification extends Equatable {
  const AppNotification({
    required this.title,
    required this.body,
    required this.kind,
    required this.group,
    this.unread = false,
  });

  final String title;
  final String body;
  final NotificationKind kind;
  final NotificationGroup group;
  final bool unread;

  @override
  List<Object?> get props => [title, body, kind, group, unread];
}
