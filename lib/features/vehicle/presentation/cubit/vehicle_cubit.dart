import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/get_vehicle.dart';

part 'vehicle_state.dart';

/// A [Cubit] is the right fit here: the vehicle screen has a single load
/// intent with no parameterized events, so the lighter Cubit API keeps the
/// boilerplate proportional to the screen's complexity.
class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit(this._getVehicle) : super(const VehicleState());

  final GetVehicle _getVehicle;

  Future<void> load() async {
    emit(state.copyWith(status: VehicleStatus.loading));
    final result = await _getVehicle(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: VehicleStatus.failure, errorMessage: f.message)),
      (vehicle) => emit(state.copyWith(status: VehicleStatus.ready, vehicle: vehicle)),
    );
  }
}
