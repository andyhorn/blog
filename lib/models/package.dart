/// A pub.dev package to display on the portfolio homepage.
class Package {
  const Package({
    required this.name,
    required this.description,
    required this.version,
    required this.stars,
    required this.pubDevUrl,
    required this.iconColor,
  });

  final String name;
  final String description;
  final String version;
  final int stars;
  final String pubDevUrl;

  /// Hex string for the icon accent color, e.g. '#A855F7'.
  final String iconColor;
}
