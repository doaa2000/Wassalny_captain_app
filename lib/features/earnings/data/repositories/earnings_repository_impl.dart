import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/earnings_report.dart';
import '../../domain/repositories/earnings_repository.dart';
import '../datasources/earnings_remote_data_source.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  const EarningsRepositoryImpl(this._remote);

  final EarningsRemoteDataSource _remote;

  @override
  Future<Either<Failure, EarningsReport>> getReport(EarningsPeriod period) async {
    try {
      return Right(await _remote.fetchReport(period));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
