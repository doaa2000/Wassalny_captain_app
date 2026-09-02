import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/captain.dart';
import '../bloc/auth_bloc.dart';

/// Shared [BlocListener] for auth pages: surfaces failures as a snackbar and
/// invokes [onAuthenticated] when a session is established (covers both
/// login and register — registration returns the captain directly now, no
/// separate OTP step). Keeps cross-cutting side-effect handling out of every
/// page.
class AuthListener extends StatelessWidget {
  const AuthListener({
    super.key,
    required this.child,
    this.onAuthenticated,
    this.onOtpSent,
    this.onResetSent,
  });

  final Widget child;
  final ValueChanged<Captain>? onAuthenticated;
  final VoidCallback? onOtpSent;
  final VoidCallback? onResetSent;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.success:
            final Captain? captain = state.captain;
            if (captain != null) onAuthenticated?.call(captain);
          case AuthStatus.otpSent:
            onOtpSent?.call();
          case AuthStatus.resetSent:
            onResetSent?.call();
          case AuthStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.danger,
                  content: Text(state.errorMessage ?? 'Something went wrong.'),
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

/// Routes a just-authenticated captain to the right screen based on their
/// approval status — used after both login and registration so a
/// pending/rejected captain never reaches the dashboard.
void routeAfterAuth(BuildContext context, Captain captain) {
  switch (captain.approvalStatus) {
    case 'approved':
      context.go(AppRoutes.dashboard);
    case 'pending':
      context.go(AppRoutes.pendingApproval);
    default: // 'rejected' | 'suspended' | anything unexpected
      context.go(AppRoutes.applicationRejected, extra: captain.rejectionReason);
  }
}
