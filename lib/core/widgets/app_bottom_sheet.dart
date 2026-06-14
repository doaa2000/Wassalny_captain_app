import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'sheet_handle.dart';

/// Centralized modal bottom sheet presentation so feature code never builds the
/// rounded surface / handle / safe-area chrome by hand.
abstract final class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (_) => _SheetContainer(child: child),
    );
  }
}

class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        border: Border(top: BorderSide(color: AppColors.darkBorderSoft)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const SheetHandle(), child],
      ),
    );
  }
}
