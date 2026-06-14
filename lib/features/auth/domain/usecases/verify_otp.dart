import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captain.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.phone, required this.code});
  final String phone;
  final String code;

  @override
  List<Object?> get props => [phone, code];
}

/// Verifies the 4-digit OTP and returns the captain session.
class VerifyOtp implements UseCase<Captain, VerifyOtpParams> {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Captain>> call(VerifyOtpParams params) {
    if (params.code.length < 4) {
      return Future.value(const Left(ValidationFailure('Enter the 4-digit code.')));
    }
    return _repository.verifyOtp(phone: params.phone, code: params.code);
  }
}
