import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
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
    final bool confirmed = await AppDialog.confirm(
      context: context,
      title: 'Log out?',
      message: "You'll need to sign in again to go back online.",
      confirmLabel: 'Log out',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
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
                            icon: Icons.directions_car_rounded,
                            label: 'Vehicle management',
                            onTap: () => context.push(AppRoutes.vehicle),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_rounded,
                            label: 'Wallet & payouts',
                            onTap: () => context.push(AppRoutes.wallet),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          const ProfileMenuTile(
                            icon: Icons.description_outlined,
                            label: 'Documents',
                            showChevron: false,
                            trailing: StatusBadge(label: 'Verified', color: AppColors.success),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.language_rounded,
                            label: 'Language',
                            showChevron: false,
                            trailing: Text('English',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedDark)),
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
                            label: 'Support center',
                            onTap: () => context.push(AppRoutes.support),
                          ),
                          const Divider(height: 1, color: AppColors.darkDivider),
                          ProfileMenuTile(
                            icon: Icons.logout_rounded,
                            iconColor: AppColors.danger,
                            labelColor: AppColors.dangerSoft,
                            label: 'Log out',
                            showChevron: false,
                            onTap: () => _logout(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('${AppConstants.appName} · ${AppConstants.appVersion}',
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
              Expanded(child: _StatBox(value: profile.totalTrips, label: 'Trips')),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: profile.acceptanceRate, label: 'Acceptance', valueColor: AppColors.success)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: profile.completionRate, label: 'Completion')),
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
