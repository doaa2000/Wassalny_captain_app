import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/vehicle.dart';

abstract interface class VehicleRepository {
  Future<Either<Failure, Vehicle>> getVehicle();
}
