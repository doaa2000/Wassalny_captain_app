import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const String _phone = '106 884 2190';
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        onAuthenticated: () => context.go(AppRoutes.dashboard),
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
                  Text(l.verifyTitle,
                      style: AppTextStyles.headline.copyWith(color: context.colors.onSurface)),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: '${l.verifySubtitle}\n',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark, height: 1.5),
                      children: [
                        TextSpan(
                          text: context.read<AuthBloc>().state.captain?.phone ?? '+20 $_phone',
                          style: AppTextStyles.bodyStrong.copyWith(color: context.colors.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  OtpInput(onChanged: (v) => _code = v),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: l.didntGetCode,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
                      children: [
                        TextSpan(
                          text: l.resendIn('0:28'),
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedDark, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => AppButton(
                      label: l.verifyAndStart,
                      isLoading: state.isLoading,
                      onPressed: () => context
                          .read<AuthBloc>()
                          .add(AuthOtpSubmitted(phone: _phone, code: _code.isEmpty ? '4078' : _code)),
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
