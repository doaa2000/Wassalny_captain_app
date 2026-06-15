import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base contract for every use case in the domain layer.
///
/// A use case is a single unit of business logic. It returns
/// `Either<Failure, T>` so callers can handle errors explicitly without
/// try/catch leaking into the presentation layer.
///
/// [T] is the success payload, [Params] the input.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Synchronous / stream-less use cases that take no input use this marker.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
