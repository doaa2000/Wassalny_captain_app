import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';

/// Shown when a captain's application was rejected (or their account
/// suspended) — `reason` is whatever the admin left in
/// `drivers.rejection_reason`, if anything.
class ApplicationRejectedPage extends StatelessWidget {
  const ApplicationRejectedPage({super.key, this.reason});

  final String? reason;

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
                  color: AppColors.danger.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.report_gmailerrorred_rounded, size: 46, color: AppColors.danger),
              ),
              const SizedBox(height: 26),
              Text(
                'Application not approved',
                textAlign: TextAlign.center,
                style: AppTextStyles.display.copyWith(color: AppColors.textPrimaryDark, fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                (reason == null || reason!.trim().isEmpty)
                    ? "Your application wasn't approved this time. Contact support for details."
                    : reason!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark, height: 1.5),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                    context.go(AppRoutes.login);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondaryDark,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Log out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
