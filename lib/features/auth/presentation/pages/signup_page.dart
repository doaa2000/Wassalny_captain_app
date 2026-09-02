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
  // ---------------------------------------------------------------------------
  // Controllers
  // ---------------------------------------------------------------------------

  // Step 1
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // Step 2
  final TextEditingController _nationalId = TextEditingController();
  final TextEditingController _license = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _plate = TextEditingController();

  // Current step
  int _currentStep = 0;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _nationalId.dispose();
    _license.dispose();
    _model.dispose();
    _year.dispose();
    _plate.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validateAccountStep();

      case 1:
        return _validateDriverStep();

      case 2:
        return true;

      default:
        return false;
    }
  }

  bool _validateAccountStep() {
    final l = AppLocalizations.of(context)!;
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      _showMessage(l.fieldRequired);
      return false;
    }

    if (!_email.text.contains('@')) {
      _showMessage(l.invalidEmail);
      return false;
    }

    if (_password.text.length < 8) {
      _showMessage(l.passwordTooShort);
      return false;
    }

    if (_password.text != _confirmPassword.text) {
      _showMessage(l.passwordMismatch);
      return false;
    }

    return true;
  }

  bool _validateDriverStep() {
    final l = AppLocalizations.of(context)!;
    if (_nationalId.text.trim().isEmpty ||
        _license.text.trim().isEmpty ||
        _model.text.trim().isEmpty ||
        _year.text.trim().isEmpty ||
        _plate.text.trim().isEmpty) {
      _showMessage(l.driverFieldsRequired);
      return false;
    }

    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // Final Submit
  // ---------------------------------------------------------------------------

  void _submit() {
    context.read<AuthBloc>().add(
          AuthRegisterSubmitted(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            nationalId: _nationalId.text.trim(),
            licenseNumber: _license.text.trim(),
          ),
        );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        // No OTP anymore.
        // We will later replace this with the proper pending/approval flow.
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
                    child: _buildCurrentStep(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppBackButton(
                onPressed: _previousStep,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.signupTitle,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _StepProgress(
            currentStep: _currentStep,
            totalSteps: 3,
          ),

          const SizedBox(height: 10),

          const _StepLabels(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Current Step
  // ---------------------------------------------------------------------------

  Widget _buildCurrentStep(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildAccountStep(context);

      case 1:
        return _buildDriverStep(context);

      case 2:
        return _buildDocumentsStep(context);

      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 1 - ACCOUNT
  // ---------------------------------------------------------------------------

  Widget _buildAccountStep(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.signupAccountInfo),

        const SizedBox(height: 8),

        Text(
          l.signupAccountInfoSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 22),

        _FieldLabel(
          label: l.fullNameLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _name,
        ),

        const SizedBox(height: 18),

        _FieldLabel(
          label: l.emailAddressLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _email,
        ),

        const SizedBox(height: 5),

        _FieldHint(
          text: l.emailHintSignup,
        ),

        const SizedBox(height: 18),

        _FieldLabel(
          label: l.passwordLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _password,
        ),

        const SizedBox(height: 5),

        _FieldHint(
          text: l.passwordHintSignup,
        ),

        const SizedBox(height: 18),

        _FieldLabel(
          label: l.confirmPasswordLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _confirmPassword,
        ),

        const SizedBox(height: 30),

        _buildContinueButton(context),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2 - DRIVER & VEHICLE
  // ---------------------------------------------------------------------------

  Widget _buildDriverStep(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.driverInfoTitle),

        const SizedBox(height: 8),

        Text(
          l.driverInfoSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 22),

        _FieldLabel(
          label: l.nationalIdLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _nationalId,
        ),

        const SizedBox(height: 18),

        _FieldLabel(
          label: l.licenseNumberLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _license,
        ),

        const SizedBox(height: 30),

        SectionHeader(l.vehicleInfoTitle),

        const SizedBox(height: 18),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(
                    label: l.vehicleModelLabel,
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
                    label: l.yearLabel,
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

        const SizedBox(height: 18),

        _FieldLabel(
          label: l.plateNumberLabel,
          required: true,
        ),

        const SizedBox(height: 7),

        AppTextField(
          controller: _plate,
        ),

        const SizedBox(height: 30),

        _buildNavigationButtons(context),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3 - DOCUMENTS
  // ---------------------------------------------------------------------------

  Widget _buildDocumentsStep(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.requiredDocumentsTitle),

        const SizedBox(height: 8),

        Text(
          l.requiredDocumentsSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 22),

        _DocumentRequirement(
          title: l.drivingLicense,
          description: l.drivingLicenseDesc,
        ),

        const SizedBox(height: 12),

        _DocumentRequirement(
          title: l.vehicleRegistration,
          description: l.vehicleRegistrationDesc,
        ),

        const SizedBox(height: 12),

        _DocumentRequirement(
          title: l.insurance,
          description: l.insuranceDesc,
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DocumentTile(
                label: l.drivingLicense,
                uploaded: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DocumentTile(
                label: l.vehicleRegistration,
                uploaded: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DocumentTile(
                label: l.insurance,
                uploaded: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        _buildApprovalNotice(context),

        const SizedBox(height: 28),

        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  label: l.submitApplication,
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _previousStep,
                  child: Text(l.back),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Buttons
  // ---------------------------------------------------------------------------

  Widget _buildContinueButton(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppButton(
      label: l.continueLabel,
      onPressed: _nextStep,
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _previousStep,
            child: Text(l.back),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: AppButton(
            label: l.continueLabel,
            onPressed: _nextStep,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Approval Notice
  // ---------------------------------------------------------------------------

  Widget _buildApprovalNotice(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                  l.applicationReview,
                 
                ),

                const SizedBox(height: 5),

                Text(
                  l.applicationReviewBody,
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

// =============================================================================
// FIELD LABEL
// =============================================================================

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

// =============================================================================
// FIELD HINT
// =============================================================================

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

// =============================================================================
// DOCUMENT REQUIREMENT
// =============================================================================

class _DocumentRequirement extends StatelessWidget {
  const _DocumentRequirement({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 19,
          color: AppColors.primary,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
               
              ),

              const SizedBox(height: 3),

              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.onSurface.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STEP PROGRESS
// =============================================================================

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final bool active = index <= currentStep;

          return Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : 7,
              ),
              decoration: BoxDecoration(
                color: active
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

// =============================================================================
// STEP LABELS
// =============================================================================

class _StepLabels extends StatelessWidget {
  const _StepLabels();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Text(
            l.accountStep,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Text(
            l.driverStep,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            l.documentsStep,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}