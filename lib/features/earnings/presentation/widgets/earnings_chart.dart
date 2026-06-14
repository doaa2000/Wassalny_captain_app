import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/earnings_report.dart';

/// Simple animated bar chart for the weekly earnings breakdown.
class EarningsChart extends StatelessWidget {
  const EarningsChart({super.key, required this.bars});

  final List<EarningsBar> bars;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((bar) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: bar.ratio.clamp(0.05, 1)),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (_, value, __) => Container(
                            width: 26,
                            height: constraints.maxHeight * value,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: bar.isToday ? AppColors.primary : AppColors.darkTrack,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bar.label,
                  style: AppTextStyles.micro.copyWith(
                    color: bar.isToday ? AppColors.primary : AppColors.textMutedDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
