import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/earnings_report.dart';
import '../repositories/earnings_repository.dart';

class GetEarningsReport implements UseCase<EarningsReport, EarningsPeriod> {
  const GetEarningsReport(this._repository);

  final EarningsRepository _repository;

  @override
  Future<Either<Failure, EarningsReport>> call(EarningsPeriod period) => _repository.getReport(period);
}
