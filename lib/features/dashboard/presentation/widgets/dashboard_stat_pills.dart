import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/dashboard_summary.dart';

/// The three earnings/trips/online pills below the status bar.
class DashboardStatPills extends StatelessWidget {
  const DashboardStatPills({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Pill(label: 'Today', value: summary.todayEarnings, valueColor: AppColors.primary)),
        const SizedBox(width: 10),
        Expanded(child: _Pill(label: 'Trips', value: summary.tripsToday)),
        const SizedBox(width: 10),
        Expanded(child: _Pill(label: 'Online', value: summary.onlineTime)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, this.valueColor = AppColors.textPrimaryDark});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTextStyles.statValue.copyWith(color: valueColor)),
          ),
        ],
      ),
    );
  }
}
