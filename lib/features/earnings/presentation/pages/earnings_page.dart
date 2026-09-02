import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/segmented_selector.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/earnings_report.dart';
import '../bloc/earnings_bloc.dart';
import '../widgets/earnings_chart.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<EarningsBloc, EarningsState>(
          builder: (context, state) {
            final report = state.report;
            final l = AppLocalizations.of(context)!;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(l.earningsTitle, style: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark)),
                  ),
                ),
                if (report == null)
                  const SliverFillRemaining(hasScrollBody: false, child: LoadingView())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.list(
                      children: [
                        SegmentedSelector<EarningsPeriod>(
                          value: state.period,
                          onChanged: (p) => context.read<EarningsBloc>().add(EarningsPeriodChanged(p)),
                          segments: [
                            SegmentItem(value: EarningsPeriod.day, label: l.earningsDay),
                            SegmentItem(value: EarningsPeriod.week, label: l.earningsWeek),
                            SegmentItem(value: EarningsPeriod.month, label: l.earningsMonth),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _TotalCard(report: report),
                        const SizedBox(height: 14),
                        AppCard(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.thisWeek,
                                  style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                              const SizedBox(height: 16),
                              EarningsChart(bars: report.chart),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStatCard(
                                icon: Icons.star_outline_rounded,
                                iconColor: AppColors.success,
                                label: l.bonusEarned,
                                value: report.bonusEarned,
                                valueColor: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MiniStatCard(
                                icon: Icons.place_outlined,
                                iconColor: AppColors.warning,
                                label: l.completed,
                                value: l.ridesCount(report.trips),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _IncentiveCard(report: report),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.report});

  final EarningsReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppCard(
      radius: 22,
      borderColor: const Color(0xFF2A6B8A),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C2A36), Color(0xFF16202A)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.totalEarnings, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
          const SizedBox(height: 4),
          Text(report.total, style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary)),
          const Divider(height: 28, color: AppColors.darkBorderSoft),
          Row(
            children: [
              _stat(l.trips, report.trips),
              const SizedBox(width: 18),
              _stat(l.online, report.onlineHours),
              const SizedBox(width: 18),
              _stat(l.avgPerTrip, report.averagePerTrip),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textPrimaryDark)),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimaryDark,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
          Text(value, style: AppTextStyles.statValue.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _IncentiveCard extends StatelessWidget {
  const _IncentiveCard({required this.report});

  final EarningsReport report;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 18,
      borderColor: const Color(0xFF4A3A6B),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2A2238), Color(0xFF1E1830)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.accentPurpleSoft, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.incentiveTitle,
                    style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text(report.incentiveSubtitle,
                    style: AppTextStyles.caption.copyWith(color: AppColors.accentPurpleSoft)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: report.incentiveProgress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: AppColors.accentPurpleSoft,
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
