part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashAuthenticated extends SplashState {
  const SplashAuthenticated();
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}

/// A valid session exists but the captain was removed by an admin.
class SplashRemoved extends SplashState {
  const SplashRemoved();
}

/// A valid session exists and the captain's application is still pending.
class SplashPendingApproval extends SplashState {
  const SplashPendingApproval();
}

/// A valid session exists but the captain's application was rejected (or
/// their account suspended).
class SplashRejected extends SplashState {
  const SplashRejected(this.reason);

  final String? reason;

  @override
  List<Object?> get props => [reason];
}
