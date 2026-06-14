import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fare_breakdown.dart';
import '../repositories/trip_repository.dart';

/// Completes the active trip and returns the settled fare breakdown.
class CompleteTrip implements UseCase<FareBreakdown, String> {
  const CompleteTrip(this._repository);

  final TripRepository _repository;

  @override
  Future<Either<Failure, FareBreakdown>> call(String requestId) {
    return _repository.completeTrip(requestId);
  }
}
