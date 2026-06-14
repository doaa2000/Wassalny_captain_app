import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BottomNavItem {
  const BottomNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// The captain app's bottom navigation bar. Stateless and driven by the
/// router's shell — it only reports tap intents.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<BottomNavItem> items = [
    BottomNavItem(icon: Icons.home_rounded, label: 'Home'),
    BottomNavItem(icon: Icons.bar_chart_rounded, label: 'Earnings'),
    BottomNavItem(icon: Icons.receipt_long_rounded, label: 'History'),
    BottomNavItem(icon: Icons.notifications_none_rounded, label: 'Alerts'),
    BottomNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceAlt,
        border: Border(top: BorderSide(color: AppColors.darkBorderSoft)),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 30, offset: Offset(0, -8))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final bool active = i == currentIndex;
              final Color color = active ? AppColors.primary : AppColors.textMutedDark;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(items[i].icon, color: color, size: 23),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
