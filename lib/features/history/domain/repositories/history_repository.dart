import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/trip_history_item.dart';

abstract interface class HistoryRepository {
  Future<Either<Failure, List<TripHistoryItem>>> getHistory();
}
