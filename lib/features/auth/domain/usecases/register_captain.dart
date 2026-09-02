import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captain.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.nationalId,
    required this.licenseNumber,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.plateNumber,
    required this.documents,
  });

  final String email;
  final String password;
  final String name;
  final String phone;
  final String nationalId;
  final String licenseNumber;
  final String vehicleModel;
  final int vehicleYear;
  final String plateNumber;

  /// Document type (e.g. `'driver_license'`) -> image bytes.
  final Map<String, Uint8List> documents;

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        phone,
        nationalId,
        licenseNumber,
        vehicleModel,
        vehicleYear,
        plateNumber,
        documents,
      ];
}

/// Submits a new captain application: creates the account, the driver/
/// vehicle record, and uploads KYC documents.
class RegisterCaptain implements UseCase<Captain, RegisterParams> {
  const RegisterCaptain(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Captain>> call(RegisterParams params) {
    if (params.name.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your full name.')));
    }
    if (!params.email.contains('@')) {
      return Future.value(const Left(ValidationFailure('Please enter a valid email.')));
    }
    if (params.password.length < 6) {
      return Future.value(
          const Left(ValidationFailure('Password must be at least 6 characters.')));
    }
    if (params.phone.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your phone number.')));
    }
    if (params.nationalId.trim().isEmpty || params.licenseNumber.trim().isEmpty) {
      return Future.value(
          const Left(ValidationFailure('Please enter your national ID and license number.')));
    }
    if (params.plateNumber.trim().isEmpty || params.vehicleModel.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your vehicle details.')));
    }
    if (params.documents.length < 3) {
      return Future.value(
          const Left(ValidationFailure('Please upload all required documents.')));
    }
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      nationalId: params.nationalId,
      licenseNumber: params.licenseNumber,
      vehicleModel: params.vehicleModel,
      vehicleYear: params.vehicleYear,
      plateNumber: params.plateNumber,
      documents: params.documents,
    );
  }
}
