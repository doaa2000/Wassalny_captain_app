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
  final TextEditingController _name = TextEditingController(text: 'Tarek Mahmoud');
  final TextEditingController _nationalId = TextEditingController(text: 'National ID · 2880…');
  final TextEditingController _license = TextEditingController(text: 'Driving license · DL-77…');
  final TextEditingController _model = TextEditingController(text: 'Toyota Corolla');
  final TextEditingController _year = TextEditingController(text: '2021');
  final TextEditingController _plate = TextEditingController(text: 'Plate · RST 4821');

  @override
  void dispose() {
    for (final c in [_name, _nationalId, _license, _model, _year, _plate]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(AuthRegisterSubmitted(
          name: _name.text,
          nationalId: _nationalId.text,
          licenseNumber: _license.text,
          phone: '106 884 2190',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: AuthListener(
        onRegistered: () => context.push(AppRoutes.otp),
        child: SafeArea(
          child: ResponsiveCenter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          AppBackButton(onPressed: () => context.pop()),
                          const SizedBox(width: 12),
                          Text('Become a captain',
                              style: AppTextStyles.titleSmall.copyWith(color: context.colors.onSurface)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _StepProgress(activeSteps: 2, totalSteps: 3),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader('Driver information'),
                        AppTextField(controller: _name),
                        const SizedBox(height: 12),
                        AppTextField(controller: _nationalId),
                        const SizedBox(height: 12),
                        AppTextField(controller: _license),
                        const SizedBox(height: 22),
                        const SectionHeader('Vehicle information'),
                        Row(
                          children: [
                            Expanded(child: AppTextField(controller: _model)),
                            const SizedBox(width: 12),
                            SizedBox(width: 92, child: AppTextField(controller: _year)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppTextField(controller: _plate),
                        const SizedBox(height: 22),
                        const SectionHeader('Documents'),
                        const Row(
                          children: [
                            Expanded(child: DocumentTile(label: 'License', uploaded: true)),
                            SizedBox(width: 11),
                            Expanded(child: DocumentTile(label: 'Vehicle reg.', uploaded: true)),
                            SizedBox(width: 11),
                            Expanded(child: DocumentTile(label: 'Insurance', uploaded: false)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) => AppButton(
                            label: 'Submit application',
                            isLoading: state.isLoading,
                            onPressed: _submit,
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
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.activeSteps, required this.totalSteps});

  final int activeSteps;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 7),
            decoration: BoxDecoration(
              color: i < activeSteps ? AppColors.primary : AppColors.darkTrack,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
