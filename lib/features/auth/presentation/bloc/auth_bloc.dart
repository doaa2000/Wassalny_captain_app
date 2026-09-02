import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/captain.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_captain.dart';
import '../../domain/usecases/register_captain.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/verify_otp.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Holds all authentication business logic. Pages dispatch intents and render
/// state; they never call use cases or the repository directly.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginCaptain login,
    required RegisterCaptain register,
    required VerifyOtp verifyOtp,
    required RequestPasswordReset requestPasswordReset,
    required AuthRepository repository,
  })  : _login = login,
        _register = register,
        _verifyOtp = verifyOtp,
        _requestPasswordReset = requestPasswordReset,
        _repository = repository,
        super(const AuthState()) {
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthOtpSubmitted>(_onVerifyOtp);
    on<AuthPasswordResetRequested>(_onResetRequested);
    on<AuthLogoutRequested>(_onLogout);
  }

  final LoginCaptain _login;
  final RegisterCaptain _register;
  final VerifyOtp _verifyOtp;
  final RequestPasswordReset _requestPasswordReset;
  final AuthRepository _repository;

  Future<void> _onLogin(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _login(LoginParams(phone: event.phone, password: event.password));
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: f.message)),
      (captain) => emit(state.copyWith(status: AuthStatus.success, captain: captain)),
    );
  }

  Future<void> _onRegister(AuthRegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _register(RegisterParams(
      email: event.email,
      password: event.password,
      name: event.name,
      phone: event.phone,
      nationalId: event.nationalId,
      licenseNumber: event.licenseNumber,
      vehicleModel: event.vehicleModel,
      vehicleYear: event.vehicleYear,
      plateNumber: event.plateNumber,
      documents: event.documents,
    ));
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: f.message)),
      (captain) => emit(state.copyWith(status: AuthStatus.success, captain: captain)),
    );
  }

  Future<void> _onVerifyOtp(AuthOtpSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _verifyOtp(VerifyOtpParams(phone: event.phone, code: event.code));
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: f.message)),
      (captain) => emit(state.copyWith(status: AuthStatus.success, captain: captain)),
    );
  }

  Future<void> _onResetRequested(AuthPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _requestPasswordReset(event.phone);
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: f.message)),
      (_) => emit(state.copyWith(status: AuthStatus.resetSent)),
    );
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();
    emit(const AuthState());
  }
}
