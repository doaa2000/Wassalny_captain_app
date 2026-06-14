import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dashboard_repository.dart';

/// Toggles the captain's availability to receive requests.
class SetOnlineStatus implements UseCase<bool, bool> {
  const SetOnlineStatus(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, bool>> call(bool online) => _repository.setOnline(online);
}
