import 'package:equatable/equatable.dart';

/// Domain-level errors. Use cases and blocs work with [Failure]s exclusively —
/// they never see exceptions or backend-specific error types.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load local data.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// The captain's account exists but is no longer an active driver (removed by
/// an admin). The app routes to the "account removed" screen.
class AccountRemovedFailure extends Failure {
  const AccountRemovedFailure(
      [super.message = 'This captain account is no longer active.']);
}
