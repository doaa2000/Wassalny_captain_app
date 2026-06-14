import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/earnings_report.dart';

abstract interface class EarningsRepository {
  Future<Either<Failure, EarningsReport>> getReport(EarningsPeriod period);
}
