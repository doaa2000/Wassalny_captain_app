import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/wallet.dart';

abstract interface class WalletRepository {
  Future<Either<Failure, Wallet>> getWallet();
  Future<Either<Failure, Unit>> requestWithdrawal();
}
