import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/support_content.dart';
import '../repositories/support_repository.dart';

class GetSupportContent implements UseCase<SupportContent, NoParams> {
  const GetSupportContent(this._repository);

  final SupportRepository _repository;

  @override
  Future<Either<Failure, SupportContent>> call(NoParams params) => _repository.getSupportContent();
}
