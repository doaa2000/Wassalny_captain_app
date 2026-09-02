import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/app_notification.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                PageHeader(
                  title: AppLocalizations.of(context)!.notificationsTitle,
                  trailing: TextButton(
                    onPressed: () => context.read<NotificationsBloc>().add(const NotificationsCleared()),
                    child: Text(AppLocalizations.of(context)!.clearAll, style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 10),
                if (state.status == NotificationsStatus.loading)
                  const Padding(padding: EdgeInsets.only(top: 80), child: LoadingView())
                else if (state.items.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: EmptyView(
                      title: AppLocalizations.of(context)!.allCaughtUp,
                      message: AppLocalizations.of(context)!.allCaughtUpSubtitle,
                      icon: Icons.notifications_none_rounded,
                    ),
                  )
                else ...[
                  if (state.today.isNotEmpty) ...[
                    SectionHeader(AppLocalizations.of(context)!.today),
                    _NotificationGroup(items: state.today),
                    const SizedBox(height: 20),
                  ],
                  if (state.earlier.isNotEmpty) ...[
                    SectionHeader(AppLocalizations.of(context)!.earlier),
                    _NotificationGroup(items: state.earlier),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  const _NotificationGroup({required this.items});

  final List<AppNotification> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _NotificationRow(notification: items[i]),
            if (i != items.length - 1) const Divider(height: 1, color: AppColors.darkDivider),
          ],
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (notification.kind) {
      NotificationKind.payout => (Icons.local_taxi_rounded, AppColors.success),
      NotificationKind.incentive => (Icons.auto_awesome_rounded, AppColors.accentPurpleSoft),
      NotificationKind.rating => (Icons.star_rounded, AppColors.warning),
      NotificationKind.document => (Icons.description_outlined, AppColors.primary),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text(notification.body,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark, height: 1.4)),
              ],
            ),
          ),
          if (notification.unread)
            Container(
              margin: const EdgeInsets.only(top: 6, left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
