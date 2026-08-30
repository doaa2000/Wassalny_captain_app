part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.phone, required this.password});
  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  const AuthRegisterSubmitted({
    required this.name,
    required this.nationalId,
    required this.licenseNumber,
    required this.email,
    required this.password,
  });

  final String name;
  final String nationalId;
  final String licenseNumber;
final String email;
  final String password;

  @override
  List<Object?> get props => [name, nationalId, licenseNumber, email, password];
}

class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted({required this.phone, required this.code});
  final String phone;
  final String code;

  @override
  List<Object?> get props => [phone, code];
}

class AuthPasswordResetRequested extends AuthEvent {
  const AuthPasswordResetRequested(this.phone);
  final String phone;

  @override
  List<Object?> get props => [phone];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
