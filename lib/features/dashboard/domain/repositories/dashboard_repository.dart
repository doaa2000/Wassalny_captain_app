import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/dashboard_summary.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, DashboardSummary>> getSummary();

  /// Persists the captain's online/offline availability and returns the new
  /// value as confirmed by the backend.
  Future<Either<Failure, bool>> setOnline(bool online);
}
