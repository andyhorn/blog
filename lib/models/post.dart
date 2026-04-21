/// Metadata extracted from a markdown post's YAML frontmatter.
class PostMeta {
  const PostMeta({
    required this.title,
    required this.date,
    required this.description,
    required this.tags,
    required this.slug,
  });

  final String title;
  final DateTime date;
  final String description;
  final List<String> tags;
  final String slug;
}

/// A parsed blog post with rendered HTML content and reading time.
class Post {
  const Post({
    required this.meta,
    required this.htmlContent,
    required this.readingTimeMinutes,
  });

  final PostMeta meta;

  /// The markdown body rendered to HTML.
  final String htmlContent;

  /// Estimated reading time: ceil(wordCount / 200).
  final int readingTimeMinutes;
}
