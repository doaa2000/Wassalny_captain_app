import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/vehicle.dart';
import '../cubit/vehicle_cubit.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            final vehicle = state.vehicle;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                PageHeader(title: AppLocalizations.of(context)!.vehicleTitle, showBack: true, onBack: () => context.pop(), fontSize: 22),
                const SizedBox(height: 14),
                if (vehicle == null)
                  const Padding(padding: EdgeInsets.only(top: 80), child: LoadingView())
                else ...[
                  _VehicleHeroCard(vehicle: vehicle),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _InfoCard(label: AppLocalizations.of(context)!.plateNumberTitle, value: vehicle.plate)),
                      const SizedBox(width: 12),
                      Expanded(child: _InfoCard(label: AppLocalizations.of(context)!.serviceTierTitle, value: vehicle.serviceTier, valueColor: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(AppLocalizations.of(context)!.documentsInsurance,
                      style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 10),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (int i = 0; i < vehicle.documents.length; i++) ...[
                          _DocumentRow(document: vehicle.documents[i]),
                          if (i != vehicle.documents.length - 1)
                            const Divider(height: 1, color: AppColors.darkDivider),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VehicleHeroCard extends StatelessWidget {
  const _VehicleHeroCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 22,
      borderColor: AppColors.darkBorder,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C2A36), AppColors.darkSurfaceAlt],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: Column(
        children: [
          const Icon(Icons.directions_car_filled_rounded, size: 60, color: Color(0xFF9AAFBD)),
          const SizedBox(height: 12),
          Text(vehicle.model, style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
          Text(vehicle.specs, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
          const SizedBox(height: 12),
          if (vehicle.approved)
            StatusBadge(label: AppLocalizations.of(context)!.activeApproved, color: AppColors.success, showDot: true),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value, this.valueColor = AppColors.textPrimaryDark});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
          const SizedBox(height: 3),
          Text(value, style: AppTextStyles.sectionTitle.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final VehicleDocument document;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final (Color color, IconData icon, String label) = switch (document.status) {
      DocumentStatus.valid => (AppColors.success, Icons.check_rounded, l.docValid),
      DocumentStatus.renewSoon => (AppColors.warning, Icons.schedule_rounded, l.docRenewSoon),
      DocumentStatus.passed => (AppColors.success, Icons.check_rounded, l.docPassed),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document.title, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                Text(document.detail, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
              ],
            ),
          ),
          Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
