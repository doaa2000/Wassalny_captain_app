import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      return Right(await _remote.fetchNotifications());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAll() async {
    try {
      await _remote.clearAll();
      return Right(unit);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
