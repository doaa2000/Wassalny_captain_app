import '../../domain/entities/vehicle.dart';

abstract interface class VehicleRemoteDataSource {
  Future<Vehicle> fetchVehicle();
}

/// In-memory vehicle seeded from the design.
class VehicleLocalDataSource implements VehicleRemoteDataSource {
  @override
  Future<Vehicle> fetchVehicle() async => const Vehicle(
        model: 'Toyota Corolla',
        specs: '2021 · Silver · 4 seats',
        plate: 'RST 4821',
        serviceTier: 'Go · Comfort',
        documents: [
          VehicleDocument(title: 'Vehicle registration', detail: 'Valid until Dec 2026', status: DocumentStatus.valid),
          VehicleDocument(title: 'Insurance', detail: 'Expires in 21 days', status: DocumentStatus.renewSoon),
          VehicleDocument(title: 'Annual inspection', detail: 'Passed · Mar 2026', status: DocumentStatus.passed),
        ],
      );
}
