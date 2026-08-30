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
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/document_tile.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final TextEditingController _nationalId = TextEditingController();
  final TextEditingController _license = TextEditingController();

  final TextEditingController _model = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _plate = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _nationalId.dispose();
    _license.dispose();
    _model.dispose();
    _year.dispose();
    _plate.dispose();

    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final nationalId = _nationalId.text.trim();
    final licenseNumber = _license.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        nationalId.isEmpty ||
        licenseNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required account and driver fields.'),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthRegisterSubmitted(
            name: name,
            email: email,
            password: password,
            nationalId: nationalId,
            licenseNumber: licenseNumber,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        // Email/password registration does not use OTP.
        onRegistered: () => context.go(AppRoutes.login),
        child: SafeArea(
          child: ResponsiveCenter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAccountSection(context),

                        const SizedBox(height: 28),

                        _buildDriverSection(context),

                        const SizedBox(height: 28),

                        _buildVehicleSection(context),

                        const SizedBox(height: 28),

                        _buildDocumentsSection(context),

                        const SizedBox(height: 28),

                        _buildApprovalNotice(context),

                        const SizedBox(height: 24),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AppButton(
                              label: 'Submit application',
                              isLoading: state.isLoading,
                              onPressed: state.isLoading ? null : _submit,
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        Center(
                          child: TextButton(
                            onPressed: () => context.go(AppRoutes.login),
                            child: Text(
                              'Already have an account? Sign in',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppBackButton(
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Become a captain',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const _StepProgress(
            activeSteps: 1,
            totalSteps: 1,
          ),

          const SizedBox(height: 18),

          Text(
            'Create your captain account',
            style: AppTextStyles.titleSmall.copyWith(
              color: context.colors.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Enter your information and submit your application for review.',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Account information'),

        const SizedBox(height: 14),

        _FieldLabel(
          label: 'Full name',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _name,
        ),

        const SizedBox(height: 16),

        _FieldLabel(
          label: 'Email address',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _email,
        ),

        const SizedBox(height: 5),

        _FieldHint(
          text: 'Use an email address you can access.',
        ),

        const SizedBox(height: 16),

        _FieldLabel(
          label: 'Password',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _password,
        ),

        const SizedBox(height: 5),

        _FieldHint(
          text: 'Choose a strong password with at least 8 characters.',
        ),
      ],
    );
  }

  Widget _buildDriverSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Driver information'),

        const SizedBox(height: 14),

        _FieldLabel(
          label: 'National ID',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _nationalId,
        ),

        const SizedBox(height: 16),

        _FieldLabel(
          label: 'Driving license number',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _license,
        ),
      ],
    );
  }

  Widget _buildVehicleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Vehicle information'),

        const SizedBox(height: 14),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(
                    label: 'Vehicle model',
                    required: true,
                  ),
                  const SizedBox(height: 7),
                  AppTextField(
                    controller: _model,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(
                    label: 'Year',
                    required: true,
                  ),
                  const SizedBox(height: 7),
                  AppTextField(
                    controller: _year,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _FieldLabel(
          label: 'Plate number',
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _plate,
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Documents'),

        const SizedBox(height: 6),

        Text(
          'Upload clear photos of your required documents.',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 14),

        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DocumentTile(
                label: 'License',
                uploaded: false,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DocumentTile(
                label: 'Vehicle reg.',
                uploaded: false,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DocumentTile(
                label: 'Insurance',
                uploaded: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Document upload will be required before your application can be approved.',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkTrack.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.colors.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application review',
                
                ),

                const SizedBox(height: 5),

                Text(
                  'After registration, your account will remain pending until an admin reviews and approves your driver information.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurface.withValues(
                      alpha: 0.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.required = false,
  });

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _FieldHint extends StatelessWidget {
  const _FieldHint({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(
        color: context.colors.onSurface.withValues(alpha: 0.5),
        fontSize: 11,
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.activeSteps,
    required this.totalSteps,
  });

  final int activeSteps;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (i) {
          return Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(
                right: i == totalSteps - 1 ? 0 : 7,
              ),
              decoration: BoxDecoration(
                color: i < activeSteps
                    ? AppColors.primary
                    : AppColors.darkTrack,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        },
      ),
    );
  }
}
