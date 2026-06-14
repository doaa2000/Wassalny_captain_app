import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wassalny_captain/core/errors/failures.dart';
import 'package:wassalny_captain/features/auth/domain/entities/captain.dart';
import 'package:wassalny_captain/features/auth/domain/repositories/auth_repository.dart';
import 'package:wassalny_captain/features/auth/domain/usecases/login_captain.dart';
import 'package:wassalny_captain/features/auth/domain/usecases/register_captain.dart';
import 'package:wassalny_captain/features/auth/domain/usecases/request_password_reset.dart';
import 'package:wassalny_captain/features/auth/domain/usecases/verify_otp.dart';
import 'package:wassalny_captain/features/auth/presentation/bloc/auth_bloc.dart';

class _MockLogin extends Mock implements LoginCaptain {}

class _MockRegister extends Mock implements RegisterCaptain {}

class _MockVerifyOtp extends Mock implements VerifyOtp {}

class _MockResetPassword extends Mock implements RequestPasswordReset {}

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockLogin login;
  late _MockRegister register;
  late _MockVerifyOtp verifyOtp;
  late _MockResetPassword resetPassword;
  late _MockAuthRepository repository;

  const captain = Captain(id: '1', name: 'Tarek Mahmoud', phone: '+20100', initials: 'TM');

  setUpAll(() {
    registerFallbackValue(const LoginParams(phone: '', password: ''));
  });

  setUp(() {
    login = _MockLogin();
    register = _MockRegister();
    verifyOtp = _MockVerifyOtp();
    resetPassword = _MockResetPassword();
    repository = _MockAuthRepository();
  });

  AuthBloc buildBloc() => AuthBloc(
        login: login,
        register: register,
        verifyOtp: verifyOtp,
        requestPasswordReset: resetPassword,
        repository: repository,
      );

  group('AuthBloc.login', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, success] when credentials are valid',
      setUp: () => when(() => login(any())).thenAnswer((_) async => const Right(captain)),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthLoginSubmitted(phone: '100', password: 'pw')),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.success, captain: captain),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, failure] when the use case returns a failure',
      setUp: () =>
          when(() => login(any())).thenAnswer((_) async => const Left(AuthFailure('Bad credentials'))),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthLoginSubmitted(phone: '100', password: 'pw')),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.failure, errorMessage: 'Bad credentials'),
      ],
    );
  });
}
