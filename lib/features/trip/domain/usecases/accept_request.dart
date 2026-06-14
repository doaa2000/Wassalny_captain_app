import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride_request.dart';
import '../repositories/trip_repository.dart';

/// Accepts a ride request, transitioning the captain into the pickup phase.
class AcceptRequest implements UseCase<RideRequest, String> {
  const AcceptRequest(this._repository);

  final TripRepository _repository;

  @override
  Future<Either<Failure, RideRequest>> call(String requestId) {
    return _repository.acceptRequest(requestId);
  }
}
