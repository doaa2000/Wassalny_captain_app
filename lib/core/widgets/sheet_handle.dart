import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The small grab handle shown at the top of bottom sheets in the design.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 5,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.darkTrack,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
