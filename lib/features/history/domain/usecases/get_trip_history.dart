import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip_history_item.dart';
import '../repositories/history_repository.dart';

class GetTripHistory implements UseCase<List<TripHistoryItem>, NoParams> {
  const GetTripHistory(this._repository);

  final HistoryRepository _repository;

  @override
  Future<Either<Failure, List<TripHistoryItem>>> call(NoParams params) => _repository.getHistory();
}
