import 'package:equatable/equatable.dart';

enum DocumentStatus { valid, renewSoon, passed }

class VehicleDocument extends Equatable {
  const VehicleDocument({required this.title, required this.detail, required this.status});

  final String title;
  final String detail;
  final DocumentStatus status;

  @override
  List<Object?> get props => [title, detail, status];
}

class Vehicle extends Equatable {
  const Vehicle({
    required this.model,
    required this.specs,
    required this.plate,
    required this.serviceTier,
    required this.documents,
    this.approved = true,
  });

  final String model;
  final String specs;
  final String plate;
  final String serviceTier;
  final List<VehicleDocument> documents;
  final bool approved;

  @override
  List<Object?> get props => [model, specs, plate, serviceTier, documents, approved];
}
