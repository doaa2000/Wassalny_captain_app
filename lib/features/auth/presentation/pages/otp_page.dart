import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/otp_input.dart';

/// Verifies the reset code sent to [phone] during the "forgot password"
/// flow. [phone] is the number the captain actually entered — never
/// hardcoded — passed in via the route's `extra`.
class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phone});

  final String phone;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _code = '';
  String? _error;

  void _submit() {
    if (_code.length < 4) {
      setState(() => _error = 'Enter the full code.');
      return;
    }
    setState(() => _error = null);
    context.read<AuthBloc>().add(AuthOtpSubmitted(phone: widget.phone, code: _code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        onAuthenticated: (captain) => routeAfterAuth(context, captain),
        child: SafeArea(
          child: ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 14, 26, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBackButton(onPressed: () => context.pop()),
                  const SizedBox(height: 24),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.dialpad_rounded, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 20),
                  Text('Verify your number',
                      style: AppTextStyles.headline.copyWith(color: context.colors.onSurface)),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: 'Enter the code sent to\n',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark, height: 1.5),
                      children: [
                        TextSpan(
                          text: widget.phone,
                          style: AppTextStyles.bodyStrong.copyWith(color: context.colors.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  OtpInput(onChanged: (v) => _code = v),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger)),
                  ],
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: "Didn't get a code? ",
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => AppButton(
                      label: 'Verify & start',
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
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
