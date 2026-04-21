/// An iOS app to display on the portfolio homepage.
class App {
  const App({
    required this.title,
    required this.description,
    required this.storeUrl,
    required this.tags,
    required this.imageUrl,
    required this.badgeColor,
  });

  final String title;
  final String description;
  final String storeUrl;
  final List<String> tags;

  /// Path to the screenshot image, e.g. 'images/focus-flow.png'.
  final String imageUrl;

  /// Hex string for the App Store badge accent, e.g. '#A855F7'.
  final String badgeColor;
}
