import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Constrains content to a comfortable reading width on tablet/desktop while
/// remaining edge-to-edge on phones. Centralizes the responsive behavior so no
/// screen needs to hardcode widths.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
