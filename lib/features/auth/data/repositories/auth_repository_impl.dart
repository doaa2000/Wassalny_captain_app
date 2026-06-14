import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/captain.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Either<Failure, Captain>> login({required String phone, required String password}) {
    return _guard(() => _remote.login(phone: phone, password: password));
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String nationalId,
    required String licenseNumber,
    required String phone,
  }) {
    return _guard(() async {
      await _remote.register(
        name: name,
        nationalId: nationalId,
        licenseNumber: licenseNumber,
        phone: phone,
      );
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> requestOtp(String phone) {
    return _guard(() async {
      await _remote.requestOtp(phone);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Captain>> verifyOtp({required String phone, required String code}) {
    return _guard(() => _remote.verifyOtp(phone: phone, code: code));
  }

  @override
  Future<Either<Failure, Unit>> requestPasswordReset(String phone) {
    return _guard(() async {
      await _remote.requestPasswordReset(phone);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    return _guard(() async {
      await _remote.logout();
      return unit;
    });
  }

  @override
  Future<Either<Failure, Captain?>> currentCaptain() {
    return _guard(() => _remote.currentCaptain());
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
