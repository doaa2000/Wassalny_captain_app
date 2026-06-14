/// Spacing and sizing tokens. Centralizing these keeps screens consistent and
/// makes the layout easy to rescale.
abstract final class AppDimensions {
  AppDimensions._();

  // Spacing scale
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 20;
  static const double spaceXl = 26;
  static const double spaceXxl = 32;

  // Common control heights
  static const double inputHeight = 54;
  static const double buttonHeight = 58;
  static const double buttonHeightSm = 50;

  // Screen horizontal padding
  static const double screenPadding = 20;

  // Bottom navigation
  static const double bottomNavHeight = 64;
}
