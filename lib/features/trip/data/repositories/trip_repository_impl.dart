import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/fare_breakdown.dart';
import '../../domain/entities/ride_request.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';

/// Translates data-source results/exceptions into the domain's
/// `Either<Failure, T>` contract. This is the bridge between the data and
/// domain layers and the place where backend errors are normalized.
class TripRepositoryImpl implements TripRepository {
  const TripRepositoryImpl(this._remote);

  final TripRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<RideRequest>>> getNearbyRequests() {
    return _guard(() async => _remote.fetchNearbyRequests());
  }

  @override
  Stream<List<RideRequest>> watchNearbyRequests() {
    return _remote.watchNearbyRequests();
  }

  @override
  Future<Either<Failure, RideRequest>> acceptRequest(String requestId) {
    return _guard(() async => _remote.acceptRequest(requestId));
  }

  @override
  Future<Either<Failure, Unit>> declineRequest(String requestId) {
    return _guard(() async {
      await _remote.declineRequest(requestId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> markArrived(String requestId) {
    return _guard(() async {
      await _remote.markArrived(requestId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> startTrip(String requestId) {
    return _guard(() async {
      await _remote.startTrip(requestId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, FareBreakdown>> completeTrip(String requestId) {
    return _guard(() async => _remote.completeTrip(requestId));
  }

  /// Shared error-handling wrapper used by every repository method.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
