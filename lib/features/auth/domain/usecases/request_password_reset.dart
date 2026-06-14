import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Requests a password-reset code for the given phone number.
class RequestPasswordReset implements UseCase<Unit, String> {
  const RequestPasswordReset(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String phone) {
    if (phone.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your phone number.')));
    }
    return _repository.requestPasswordReset(phone);
  }
}
