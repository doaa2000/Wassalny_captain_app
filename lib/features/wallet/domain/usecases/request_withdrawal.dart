import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wallet_repository.dart';

class RequestWithdrawal implements UseCase<Unit, NoParams> {
  const RequestWithdrawal(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => _repository.requestWithdrawal();
}
