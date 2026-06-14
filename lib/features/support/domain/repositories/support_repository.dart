import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/support_content.dart';

abstract interface class SupportRepository {
  Future<Either<Failure, SupportContent>> getSupportContent();
}
