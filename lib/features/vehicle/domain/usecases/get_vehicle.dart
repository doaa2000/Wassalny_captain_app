import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicle implements UseCase<Vehicle, NoParams> {
  const GetVehicle(this._repository);

  final VehicleRepository _repository;

  @override
  Future<Either<Failure, Vehicle>> call(NoParams params) => _repository.getVehicle();
}
