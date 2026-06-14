import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sheet_handle.dart';

/// The dark rounded sheet anchored to the bottom of every map-based trip
/// screen. Encapsulates the surface, border, radius and safe-area padding.
class MapSheet extends StatelessWidget {
  const MapSheet({
    super.key,
    required this.child,
    this.showHandle = true,
    this.borderColor = AppColors.darkBorderSoft,
  });

  final Widget child;
  final bool showHandle;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 22),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceAlt,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 40, offset: Offset(0, -12))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHandle) const Center(child: SheetHandle()),
          child,
        ],
      ),
    );
  }
}
