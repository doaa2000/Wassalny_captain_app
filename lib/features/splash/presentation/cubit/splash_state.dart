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
