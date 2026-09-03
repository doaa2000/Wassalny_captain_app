import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/map_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../trip/domain/entities/ride_request.dart';
import '../../../trip/presentation/bloc/trip_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_stat_pills.dart';
import '../widgets/nearby_request_card.dart';
import '../widgets/online_toggle.dart';

/// Captain home: live map, online toggle, earnings glance and nearby requests.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _openRequest(BuildContext context, RideRequest request) {
    context.read<TripBloc>().add(TripRequestOpened(request));
    context.push(AppRoutes.incomingRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading || state.status == DashboardStatus.initial) {
            return const LoadingView();
          }
          if (state.status == DashboardStatus.failure) {
            return ErrorView(
              message: AppLocalizations.of(context)!.dashboardError,
              onRetry: () => context.read<DashboardBloc>().add(const DashboardStarted()),
            );
          }

          return MapScaffold(
            variant: MapVariant.idle,
            builder: (context, map, myLocationButton) {
              return Stack(
                children: [
                  Positioned.fill(child: map),
                  if (!state.online)
                    Positioned.fill(child: Container(color: AppColors.overlay)),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
                      child: Column(
                        children: [
                          _StatusBar(
                            online: state.online,
                            onToggle: () => context.read<DashboardBloc>().add(const DashboardOnlineToggled()),
                            onAvatarTap: () => context.go(AppRoutes.profile),
                          ),
                          const SizedBox(height: 12),
                          if (state.summary != null) DashboardStatPills(summary: state.summary!),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MapSheetStack(
                      myLocationButton: myLocationButton,
                      sheet: _DashboardSheet(
                        online: state.online,
                        requests: state.requests,
                        onRequestTap: (r) => _openRequest(context, r),
                        onGoOnline: () => context.read<DashboardBloc>().add(const DashboardOnlineToggled()),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.online, required this.onToggle, required this.onAvatarTap});

  final bool online;
  final VoidCallback onToggle;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: const Center(child: InitialsAvatar.captain(initials: 'TM', size: 32, radius: 11)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: online ? AppColors.success : AppColors.textMutedDark,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    online ? AppLocalizations.of(context)!.dashboardOnline : AppLocalizations.of(context)!.dashboardOffline,
                    style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark),
                  ),
                ),
                OnlineToggle(online: online, onChanged: (_) => onToggle()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardSheet extends StatelessWidget {
  const _DashboardSheet({
    required this.online,
    required this.requests,
    required this.onRequestTap,
    required this.onGoOnline,
  });

  final bool online;
  final List<RideRequest> requests;
  final ValueChanged<RideRequest> onRequestTap;
  final VoidCallback onGoOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        border: Border(top: BorderSide(color: AppColors.darkBorderSoft)),
      ),
      child: SingleChildScrollView(
        child: online ? _onlineContent(context) : _offlineContent(context),
      ),
    );
  }

  Widget _onlineContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.nearbyRequests, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textPrimaryDark)),
            const Spacer(),
            StatusBadge(label: AppLocalizations.of(context)!.live, color: AppColors.success, showDot: true),
          ],
        ),
        const SizedBox(height: 12),
        ...requests.map((r) => NearbyRequestCard(request: r, onTap: () => onRequestTap(r))),
      ],
    );
  }

  Widget _offlineContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: const Icon(Icons.history_toggle_off_rounded, color: AppColors.textMutedDark, size: 30),
        ),
        const SizedBox(height: 14),
        Text(AppLocalizations.of(context)!.dashboardOffline, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textPrimaryDark)),
        const SizedBox(height: 5),
        Text(
          AppLocalizations.of(context)!.dashboardOfflineSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
        ),
        const SizedBox(height: 18),
        AppButton(label: AppLocalizations.of(context)!.goOnline, variant: AppButtonVariant.success, onPressed: onGoOnline),
      ],
    );
  }
}
