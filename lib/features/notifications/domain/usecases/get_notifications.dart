import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications implements UseCase<List<AppNotification>, NoParams> {
  const GetNotifications(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, List<AppNotification>>> call(NoParams params) => _repository.getNotifications();
}
