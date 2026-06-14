import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captain.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.phone, required this.password});
  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}

/// Signs a captain in with phone + password.
class LoginCaptain implements UseCase<Captain, LoginParams> {
  const LoginCaptain(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Captain>> call(LoginParams params) {
    if (params.phone.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your phone number.')));
    }
    if (params.password.isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your password.')));
    }
    return _repository.login(phone: params.phone, password: params.password);
  }
}
