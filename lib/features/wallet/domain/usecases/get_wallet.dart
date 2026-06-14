import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWallet implements UseCase<Wallet, NoParams> {
  const GetWallet(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(NoParams params) => _repository.getWallet();
}
