import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captain_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  List<Object?> get props => [name, phone];
}

/// Updates the captain's profile (name / phone) and returns the refreshed profile.
class UpdateProfile implements UseCase<CaptainProfile, UpdateProfileParams> {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, CaptainProfile>> call(UpdateProfileParams params) {
    if (params.name.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Please enter your name.')));
    }
    return _repository.updateProfile(name: params.name, phone: params.phone);
  }
}