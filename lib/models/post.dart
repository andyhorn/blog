import 'package:jaspr/jaspr.dart';

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

  @encoder
  Map<String, dynamic> encode() => {
    'title': title,
    'date': date.toIso8601String(),
    'description': description,
    'tags': tags,
    'slug': slug,
  };

  @decoder
  static PostMeta decode(Map<String, dynamic> data) => PostMeta(
    title: data['title'] as String,
    date: DateTime.parse(data['date'] as String),
    description: data['description'] as String,
    tags: List<String>.from(data['tags'] as List),
    slug: data['slug'] as String,
  );
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

  @encoder
  Map<String, dynamic> encode() => {
    'meta': meta.encode(),
    'htmlContent': htmlContent,
    'readingTimeMinutes': readingTimeMinutes,
  };

  @decoder
  static Post decode(Map<String, dynamic> data) => Post(
    meta: PostMeta.decode(data['meta'] as Map<String, dynamic>),
    htmlContent: data['htmlContent'] as String,
    readingTimeMinutes: data['readingTimeMinutes'] as int,
  );
}
