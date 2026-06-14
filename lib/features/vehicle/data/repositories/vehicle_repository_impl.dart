import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl(this._remote);

  final VehicleRemoteDataSource _remote;

  @override
  Future<Either<Failure, Vehicle>> getVehicle() async {
    try {
      return Right(await _remote.fetchVehicle());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
