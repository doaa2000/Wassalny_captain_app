import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

part 'splash_state.dart';

/// Decides, after the splash delay, whether to route to the dashboard (existing
/// session) or the login screen. Keeps the routing decision out of the widget.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authRepository) : super(const SplashInitial());

  final AuthRepository _authRepository;

  Future<void> bootstrap() async {
    await Future<void>.delayed(AppConstants.splashDelay);
    final result = await _authRepository.currentCaptain();
    if (isClosed) return;
    emit(result.fold(
      (failure) => failure is AccountRemovedFailure
          ? const SplashRemoved()
          : const SplashUnauthenticated(),
      (captain) =>
          captain != null ? const SplashAuthenticated() : const SplashUnauthenticated(),
    ));
  }
}
