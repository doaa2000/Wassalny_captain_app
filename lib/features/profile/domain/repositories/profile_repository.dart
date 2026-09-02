import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/captain_profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, CaptainProfile>> getProfile();
  Future<Either<Failure, CaptainProfile>> updateProfile({
    required String name,
    required String phone,
  });
}
