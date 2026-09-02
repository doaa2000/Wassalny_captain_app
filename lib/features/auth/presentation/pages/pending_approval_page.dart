import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';

/// Shown right after a captain registers, and every time they log in while
/// their application is still `pending` — makes it clear why they see no
/// ride requests, instead of a silently broken dashboard.
class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

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
                child: const Icon(Icons.hourglass_top_rounded, size: 46, color: AppColors.primary),
              ),
              const SizedBox(height: 26),
              Text(
                'Application under review',
                textAlign: TextAlign.center,
                style: AppTextStyles.display.copyWith(color: AppColors.textPrimaryDark, fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                "Thanks for signing up! Our team is reviewing your documents and vehicle "
                "details. You'll be able to go online once your application is approved.",
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
