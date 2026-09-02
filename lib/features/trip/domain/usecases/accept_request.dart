import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride_request.dart';
import '../repositories/trip_repository.dart';

/// Accepts a ride request, transitioning the captain into the pickup phase.
class AcceptRequest implements UseCase<RideRequest, AcceptRequestParams> {
  const AcceptRequest(this._repository);

  final TripRepository _repository;

  @override
  Future<Either<Failure, RideRequest>> call(AcceptRequestParams params) {
    return _repository.acceptRequest(params.requestId, offeredFare: params.offeredFare);
  }
}

class AcceptRequestParams extends Equatable {
  const AcceptRequestParams({required this.requestId, this.offeredFare});

  final String requestId;
  final double? offeredFare;

  @override
  List<Object?> get props => [requestId, offeredFare];
}
