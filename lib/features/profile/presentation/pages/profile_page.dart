import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/captain_profile.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_menu_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final bool confirmed = await AppDialog.confirm(
      context: context,
      title: l.logOutQuestion,
      message: l.logOutMessage,
      confirmLabel: l.logOut,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    context.go(AppRoutes.login);
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final LocaleController controller = sl<LocaleController>();
    final Locale? selected = await showDialog<Locale>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.languageLabel, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textPrimaryDark)),
        backgroundColor: AppColors.darkSurfaceAlt,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(const Locale('en')),
            child: Text(l.english, style: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(const Locale('ar')),
            child: Text(l.arabic, style: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark)),
          ),
        ],
      ),
    );
    if (selected != null && context.mounted) {
      await controller.setLocale(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          if (profile == null) return const LoadingView();
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _ProfileHeader(profile: profile),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  children: [
                    AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ProfileMenuTile(
                            icon: Icons.edit_outlined,
                            label: l.editProfileTitle,
                            onTap: () async {
                              await context.push(AppRoutes.editProfile);
                              // Refresh so the header reflects any saved changes.
                              if (context.mounted) {
                                context.read<ProfileBloc>().add(const ProfileStarted());
                              }
                            },
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.directions_car_rounded,
                            label: l.vehicleManagement,
                            onTap: () => context.push(AppRoutes.vehicle),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_rounded,
                            label: l.walletAndPayouts,
                            onTap: () => context.push(AppRoutes.wallet),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.description_outlined,
                            label: l.documentsLabel,
                            showChevron: false,
                            trailing: StatusBadge(label: l.verified, color: AppColors.success),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ListenableBuilder(
                            listenable: sl<LocaleController>(),
                            builder: (context, _) => ProfileMenuTile(
                              icon: Icons.language_rounded,
                              label: l.languageLabel,
                              onTap: () => _pickLanguage(context),
                              trailing: Text(
                                sl<LocaleController>().isArabic ? l.arabic : l.english,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ProfileMenuTile(
                            icon: Icons.help_outline_rounded,
                            iconColor: AppColors.textSecondaryDark,
                            label: l.supportCenter,
                            onTap: () => context.push(AppRoutes.support),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.logout_rounded,
                            iconColor: AppColors.danger,
                            labelColor: AppColors.dangerSoft,
                            label: l.logOut,
                            showChevron: false,
                            onTap: () => _logout(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('${l.appName} · ${l.appVersion}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textFaintDark)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final CaptainProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 16, 22, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C2A36), AppColors.darkSurfaceAlt],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        border: Border(bottom: BorderSide(color: AppColors.darkBorderSoft)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InitialsAvatar.captain(initials: profile.initials, size: 68, radius: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
                    Text(profile.memberSince, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 5),
                    StatusBadge(label: profile.ratingLabel, color: AppColors.warning),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _StatBox(value: profile.totalTrips, label: AppLocalizations.of(context)!.trips)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: profile.acceptanceRate, label: AppLocalizations.of(context)!.acceptance, valueColor: AppColors.success)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: profile.completionRate, label: AppLocalizations.of(context)!.completion)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label, this.valueColor = AppColors.textPrimaryDark});

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.statValue.copyWith(color: valueColor)),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
        ],
      ),
    );
  }
}
