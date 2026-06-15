import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._remote);

  final WalletRemoteDataSource _remote;

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    try {
      return Right(await _remote.fetchWallet());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> requestWithdrawal() async {
    try {
      await _remote.requestWithdrawal();
      return const Right(unit);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
