part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, otpSent, resetSent, registered, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.captain,
    this.errorMessage,
  });

  final AuthStatus status;
  final Captain? captain;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({AuthStatus? status, Captain? captain, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      captain: captain ?? this.captain,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, captain, errorMessage];
}
