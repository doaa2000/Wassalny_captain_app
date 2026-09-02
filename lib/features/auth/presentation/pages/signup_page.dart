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

const int _kStepCount = 3;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _step = 0;

  // One form key per step, so validation only checks the fields visible on
  // that step — not the whole application at once.
  final List<GlobalKey<FormState>> _formKeys =
      List.generate(_kStepCount, (_) => GlobalKey<FormState>());

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

  void _next() {
    if (!_formKeys[_step].currentState!.validate()) return;
    if (_step < _kStepCount - 1) {
      setState(() => _step += 1);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step -= 1);
    } else {
      context.pop();
    }
  }

  void _submit() {
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
    final Color muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);

    return Scaffold(
      body: AuthListener(
        onAuthenticated: (captain) => routeAfterAuth(context, captain),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    AppBackButton(onPressed: _back),
                    const SizedBox(width: 14),
                    Expanded(child: _StepProgress(step: _step, count: _kStepCount)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(_stepTitle(_step), style: AppTextStyles.title),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(_stepSubtitle(_step), style: AppTextStyles.body.copyWith(color: muted)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: IndexedStack(
                    index: _step,
                    children: [
                      _buildDetailsStep(),
                      _buildVehicleStep(),
                      _buildDocumentsStep(muted),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => AppButton(
                    label: _step == _kStepCount - 1 ? 'Submit application' : 'Continue',
                    isLoading: state.isLoading,
                    onPressed: state.isLoading ? null : _next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stepTitle(int step) => switch (step) {
        0 => 'Your details',
        1 => 'Your vehicle',
        _ => 'Documents',
      };

  String _stepSubtitle(int step) => switch (step) {
        0 => 'How riders and support will reach you.',
        1 => 'What you\'ll be driving.',
        _ => 'Tap each one to take or choose a photo.',
      };

  Widget _buildDetailsStep() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Password',
            controller: _password,
            obscureText: true,
            validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
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
        ],
      ),
    );
  }

  Widget _buildVehicleStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildDocumentsStep(Color muted) {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            Text(_documentError!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger)),
          ],
        ],
      ),
    );
  }
}

/// Segmented progress bar: one filled/empty pill per step.
class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step, required this.count});

  final int step;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 6,
              decoration: BoxDecoration(
                color: i <= step
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          if (i != count - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}
