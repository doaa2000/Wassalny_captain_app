import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';

/// Shared [BlocListener] for auth pages: surfaces failures as a snackbar and
/// invokes [onAuthenticated] when a session is established. Keeps cross-cutting
/// side-effect handling out of every page.
class AuthListener extends StatelessWidget {
  const AuthListener({
    super.key,
    required this.child,
    this.onAuthenticated,
    this.onOtpSent,
    this.onResetSent,
    this.onRegistered,
  });

  final Widget child;
  final VoidCallback? onAuthenticated;
  final VoidCallback? onOtpSent;
  final VoidCallback? onResetSent;
  final VoidCallback? onRegistered;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.success:
            onAuthenticated?.call();
          case AuthStatus.otpSent:
            onOtpSent?.call();
          case AuthStatus.resetSent:
            onResetSent?.call();
          case AuthStatus.registered:
            onRegistered?.call();
          case AuthStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.danger,
                  content: Text(state.errorMessage ?? l.somethingWentWrong),
                ),
              );
          case AuthStatus.initial:
          case AuthStatus.loading:
            break;
        }
      },
      child: child,
    );
  }
}
