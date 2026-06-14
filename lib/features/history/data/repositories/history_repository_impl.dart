import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._remote);

  final HistoryRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<TripHistoryItem>>> getHistory() async {
    try {
      return Right(await _remote.fetchHistory());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
