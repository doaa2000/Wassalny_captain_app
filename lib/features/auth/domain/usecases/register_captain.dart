import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.nationalId,
    required this.licenseNumber,
    required this.email,
    required this.password,
  });

  final String name;
  final String nationalId;
  final String licenseNumber;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, nationalId, licenseNumber, email, password];
}

/// Submits a new captain application.
class RegisterCaptain implements UseCase<Unit, RegisterParams> {
  const RegisterCaptain(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) {
    if (params.name.trim().isEmpty) {
      return Future.value(
          const Left(ValidationFailure('Please enter your full name.')));
    }
    return _repository.register(
      name: params.name,
      nationalId: params.nationalId,
      licenseNumber: params.licenseNumber,
      email: params.email,
      password: params.password,
    );
  }
}
