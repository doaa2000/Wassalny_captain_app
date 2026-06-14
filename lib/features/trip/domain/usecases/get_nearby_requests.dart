import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride_request.dart';
import '../repositories/trip_repository.dart';

/// Fetches the ride requests available near the online captain.
class GetNearbyRequests implements UseCase<List<RideRequest>, NoParams> {
  const GetNearbyRequests(this._repository);

  final TripRepository _repository;

  @override
  Future<Either<Failure, List<RideRequest>>> call(NoParams params) {
    return _repository.getNearbyRequests();
  }
}
