import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Generic segmented control (used by Earnings period switching and reusable
/// anywhere a small inline tab selector is needed).
class SegmentedSelector<T> extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentItem<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: segments.map((s) {
          final bool active = s.value == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(s.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  s.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: active ? AppColors.onPrimary : AppColors.textSecondaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentItem<T> {
  const SegmentItem({required this.value, required this.label});
  final T value;
  final String label;
}
