/// Centralized asset paths. Widgets reference these constants instead of raw
/// string paths so asset locations live in one place.
abstract final class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';

  /// The full Wassalny Captain brand logo (transparent background).
  static const String logo = '$_images/logo.png';
}
