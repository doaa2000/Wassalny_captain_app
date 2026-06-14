import 'package:flutter/material.dart';

/// Convenience accessors on [BuildContext] for theme and responsiveness.
/// Keeps widget code terse and consistent.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;

  MediaQueryData get mq => MediaQuery.of(this);
  Size get screenSize => mq.size;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;

  bool get isDark => theme.brightness == Brightness.dark;

  /// Breakpoints for responsive layouts.
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Returns one of the supplied values based on the current breakpoint.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
