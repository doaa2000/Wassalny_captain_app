import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';

/// Shown when a captain's account was removed by an admin: the auth session is
/// signed out and the captain is told their account is no longer active.
class AccountRemovedPage extends StatefulWidget {
  const AccountRemovedPage({super.key});

  @override
  State<AccountRemovedPage> createState() => _AccountRemovedPageState();
}

class _AccountRemovedPageState extends State<AccountRemovedPage> {
  @override
  void initState() {
    super.initState();
    // Clear the dangling session so the captain can't loop back in.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_off_rounded,
                    size: 46, color: AppColors.primary),
              ),
              const SizedBox(height: 26),
              Text(
                'Account no longer active',
                textAlign: TextAlign.center,
                style: AppTextStyles.display
                    .copyWith(color: AppColors.textPrimaryDark, fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                'Your captain account has been removed by the Wassalny team. '
                'If you think this is a mistake, please contact support.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondaryDark, height: 1.5),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('Back to login',
                      style: AppTextStyles.body
                          .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
