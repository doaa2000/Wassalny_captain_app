import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/brand_logo.dart';
import '../widgets/phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phone = TextEditingController(text: '106 884 2190');
  final TextEditingController _password = TextEditingController(text: 'password');

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(phone: _phone.text, password: _password.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        onAuthenticated: () => context.go(AppRoutes.dashboard),
        child: SafeArea(
          child: ResponsiveCenter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 40, 26, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BrandLogo(),
                  const SizedBox(height: 22),
                  Text('Captain login', style: AppTextStyles.headline.copyWith(color: context.colors.onSurface, fontSize: 28)),
                  const SizedBox(height: 6),
                  Text('Sign in to start driving.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 26),
                  PhoneField(controller: _phone),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Password',
                    controller: _password,
                    obscureText: true,
                    prefix: const Icon(Icons.lock_outline_rounded, size: 19, color: AppColors.textMutedDark),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: Text('Forgot password?',
                          style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => AppButton(
                      label: 'Log in',
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New captain? ',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark)),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.signup),
                        child: Text('Register to drive',
                            style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ),
                    ],
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
