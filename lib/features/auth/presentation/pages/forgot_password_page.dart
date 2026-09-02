import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/phone_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        onResetSent: () => context.push(AppRoutes.otp, extra: _phone.text.trim()),
        child: SafeArea(
          child: ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 14, 26, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(alignment: Alignment.centerLeft, child: AppBackButton(onPressed: () => context.pop())),
                  const SizedBox(height: 24),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 20),
                  Text('Reset password',
                      style: AppTextStyles.headline.copyWith(color: context.colors.onSurface)),
                  const SizedBox(height: 8),
                  Text("Enter your registered phone and we'll send a reset code.",
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
                  const SizedBox(height: 26),
                  PhoneField(controller: _phone),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => AppButton(
                      label: 'Send reset code',
                      isLoading: state.isLoading,
                      onPressed: () => context.read<AuthBloc>().add(AuthPasswordResetRequested(_phone.text)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Back to login',
                    variant: AppButtonVariant.ghost,
                    height: 50,
                    onPressed: () => context.go(AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
