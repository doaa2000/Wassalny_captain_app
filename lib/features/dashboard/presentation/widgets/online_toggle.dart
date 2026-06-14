import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Custom pill toggle matching the design's online/offline switch.
class OnlineToggle extends StatelessWidget {
  const OnlineToggle({super.key, required this.online, required this.onChanged});

  final bool online;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!online),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 30,
        decoration: BoxDecoration(
          color: online ? AppColors.success : AppColors.darkTrack,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: online ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
