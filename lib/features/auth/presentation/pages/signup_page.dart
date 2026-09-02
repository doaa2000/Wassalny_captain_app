import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_listener.dart';
import '../widgets/document_tile.dart';

/// Maps the 3 KYC documents this form collects to the server's
/// `document_type` enum values.
const Map<String, String> _kDocumentTypes = {
  'License': 'driver_license',
  'Vehicle reg.': 'vehicle_registration',
  'Insurance': 'vehicle_insurance',
};

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _nationalId = TextEditingController();
  final _licenseNumber = TextEditingController();
  final _vehicleModel = TextEditingController();
  final _vehicleYear = TextEditingController();
  final _plateNumber = TextEditingController();

  final Map<String, Uint8List> _documents = {};
  String? _documentError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _nationalId.dispose();
    _licenseNumber.dispose();
    _vehicleModel.dispose();
    _vehicleYear.dispose();
    _plateNumber.dispose();
    super.dispose();
  }

  Future<void> _pickDocument(String label) async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (file == null) return;
    final Uint8List bytes = await file.readAsBytes();
    setState(() {
      _documents[_kDocumentTypes[label]!] = bytes;
      _documentError = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_documents.length < _kDocumentTypes.length) {
      setState(() => _documentError = 'Please upload all 3 documents.');
      return;
    }
    final int? year = int.tryParse(_vehicleYear.text.trim());
    if (year == null) return;
    context.read<AuthBloc>().add(
          AuthRegisterSubmitted(
            email: _email.text.trim(),
            password: _password.text,
            name: _name.text.trim(),
            phone: _phone.text.trim(),
            nationalId: _nationalId.text.trim(),
            licenseNumber: _licenseNumber.text.trim(),
            vehicleModel: _vehicleModel.text.trim(),
            vehicleYear: year,
            plateNumber: _plateNumber.text.trim(),
            documents: _documents,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthListener(
        onAuthenticated: (captain) => routeAfterAuth(context, captain),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppBackButton(),
                  const SizedBox(height: 20),
                  Text('Become a captain', style: AppTextStyles.title),
                  const SizedBox(height: 6),
                  Text(
                    'Tell us about you and your vehicle. An admin reviews every application.',
                    style: AppTextStyles.body.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65)),
                  ),
                  const SizedBox(height: 28),

                  Text('Your details', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Full name',
                    controller: _name,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Email',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Password',
                    controller: _password,
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'At least 6 characters' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Phone number',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'National ID',
                    controller: _nationalId,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Driving license number',
                    controller: _licenseNumber,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),
                  Text('Your vehicle', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Vehicle model',
                    controller: _vehicleModel,
                    hintText: 'e.g. Toyota Corolla 2020',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Vehicle year',
                    controller: _vehicleYear,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || int.tryParse(v.trim()) == null) ? 'Enter a year' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Plate number',
                    controller: _plateNumber,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),
                  Text('Documents', style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  Text('Tap each one to take or choose a photo.',
                      style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (final String label in _kDocumentTypes.keys) ...[
                        Expanded(
                          child: DocumentTile(
                            label: label,
                            uploaded: _documents.containsKey(_kDocumentTypes[label]),
                            onTap: () => _pickDocument(label),
                          ),
                        ),
                        if (label != _kDocumentTypes.keys.last) const SizedBox(width: 11),
                      ],
                    ],
                  ),
                  if (_documentError != null) ...[
                    const SizedBox(height: 8),
                    Text(_documentError!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger)),
                  ],

                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => AppButton(
                      label: 'Submit application',
                      isLoading: state.isLoading,
                      onPressed: state.isLoading ? null : _submit,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Already have an account? Log in'),
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
