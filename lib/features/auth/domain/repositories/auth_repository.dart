import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/captain.dart';

/// Authentication domain contract. The presentation layer talks only to this.
abstract interface class AuthRepository {
  Future<Either<Failure, Captain>> login({required String phone, required String password});

  Future<Either<Failure, Unit>> register({
    required String name,
    required String nationalId,
    required String licenseNumber,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> requestOtp(String phone);

  Future<Either<Failure, Captain>> verifyOtp({required String phone, required String code});

  Future<Either<Failure, Unit>> requestPasswordReset(String phone);

  Future<Either<Failure, Unit>> logout();

  /// The currently signed-in captain, if any (used to skip the login screen).
  Future<Either<Failure, Captain?>> currentCaptain();
}
