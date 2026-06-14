import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/support_content.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl(this._remote);

  final SupportRemoteDataSource _remote;

  @override
  Future<Either<Failure, SupportContent>> getSupportContent() async {
    try {
      return Right(await _remote.fetchSupportContent());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
