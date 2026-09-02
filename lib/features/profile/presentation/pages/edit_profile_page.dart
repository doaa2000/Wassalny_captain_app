import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/captain_profile.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    final l = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.fieldRequired)));
      return;
    }

    context.read<ProfileBloc>().add(ProfileUpdated(name: name, phone: phone));
  }

  /// Pops back to the profile page once the save succeeds, so the caller can
  /// refresh and show the updated name everywhere.
  void _onSaveSuccess(ProfileState state) {
    if (!state.isSaving && state.errorMessage == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (prev, curr) => prev.isSaving != curr.isSaving,
          listener: (context, state) => _onSaveSuccess(state),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
            final profile = state.profile;
            if (profile == null) return const LoadingView();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, l),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAvatar(profile),
                        const SizedBox(height: 24),
                        AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppTextField(
                                label: l.fullNameLabel,
                                controller: _nameController,
                                prefix: const Icon(Icons.person_outline_rounded, size: 19, color: AppColors.textMutedDark),
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: l.phoneLabel,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                prefix: const Icon(Icons.phone_outlined, size: 19, color: AppColors.textMutedDark),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: l.saveChanges,
                          isLoading: state.isSaving,
                          onPressed: state.isSaving ? null : _save,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: Row(
        children: [
          const AppBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.editProfileTitle,
              style: AppTextStyles.titleSmall.copyWith(color: context.colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(CaptainProfile profile) {
    return Center(
      child: Column(
        children: [
          InitialsAvatar.captain(initials: profile.initials, size: 84, radius: 26),
          const SizedBox(height: 12),
          Text(
            profile.name,
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 4),
          Text(
            profile.memberSince,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }
}