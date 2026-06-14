import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_text_styles.dart';
import 'app_back_button.dart';

/// Large screen title with an optional back button and trailing action — used
/// by the secondary (pushed) pages so they share consistent chrome.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.fontSize = 24,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          AppBackButton(onPressed: onBack),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.title.copyWith(color: context.colors.onSurface, fontSize: fontSize),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
