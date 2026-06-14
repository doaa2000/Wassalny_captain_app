import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base contract for every use case in the domain layer.
///
/// A use case is a single unit of business logic. It returns
/// `Either<Failure, Type>` so callers can handle errors explicitly without
/// try/catch leaking into the presentation layer.
///
/// [Type] is the success payload, [Params] the input.
abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Synchronous / stream-less use cases that take no input use this marker.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
