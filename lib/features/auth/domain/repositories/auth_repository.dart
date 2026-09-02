import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/captain.dart';

/// Authentication domain contract. The presentation layer talks only to this.
abstract interface class AuthRepository {
  Future<Either<Failure, Captain>> login({required String phone, required String password});

  /// Registers a new captain (email + password, same mechanism as [login]).
  /// Creates the driver/vehicle record and uploads KYC [documents] in one
  /// go, returning the captain directly — no separate OTP step.
  Future<Either<Failure, Captain>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String nationalId,
    required String licenseNumber,
    required String vehicleModel,
    required int vehicleYear,
    required String plateNumber,
    required Map<String, Uint8List> documents,
  });

  Future<Either<Failure, Unit>> requestOtp(String phone);

  Future<Either<Failure, Captain>> verifyOtp({required String phone, required String code});

  Future<Either<Failure, Unit>> requestPasswordReset(String phone);

  Future<Either<Failure, Unit>> logout();

  /// The currently signed-in captain, if any (used to skip the login screen).
  Future<Either<Failure, Captain?>> currentCaptain();
}
