part of 'vehicle_cubit.dart';

enum VehicleStatus { initial, loading, ready, failure }

class VehicleState extends Equatable {
  const VehicleState({this.status = VehicleStatus.initial, this.vehicle, this.errorMessage});

  final VehicleStatus status;
  final Vehicle? vehicle;
  final String? errorMessage;

  VehicleState copyWith({VehicleStatus? status, Vehicle? vehicle, String? errorMessage}) {
    return VehicleState(
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vehicle, errorMessage];
}
