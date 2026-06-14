import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captain_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile implements UseCase<CaptainProfile, NoParams> {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, CaptainProfile>> call(NoParams params) => _repository.getProfile();
}
