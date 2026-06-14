import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_notification.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications();
  Future<Either<Failure, Unit>> clearAll();
}
