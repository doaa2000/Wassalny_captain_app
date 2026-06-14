import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummary implements UseCase<DashboardSummary, NoParams> {
  const GetDashboardSummary(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, DashboardSummary>> call(NoParams params) => _repository.getSummary();
}
