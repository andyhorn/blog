import 'dart:io';

import 'package:markdown/markdown.dart' as md;
import 'package:yaml/yaml.dart';

import '../models/post.dart';

/// Loads and parses all markdown posts from [content/posts/].
///
/// Called server-side during pre-rendering. Returns posts sorted
/// newest-first by date.
List<Post> loadAllPosts() {
  final dir = Directory('content/posts');
  if (!dir.existsSync()) return [];

  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.md')).toList()
    ..sort((a, b) => b.path.compareTo(a.path));

  return files.map(_parsePost).whereType<Post>().toList();
}

Post? _parsePost(File file) {
  final filename = file.uri.pathSegments.last;
  // Expect format: YYYY-MM-DD-slug.md
  final slugMatch = RegExp(r'^\d{4}-\d{2}-\d{2}-(.+)\.md$').firstMatch(filename);
  if (slugMatch == null) return null;
  final slug = slugMatch.group(1)!;

  final raw = file.readAsStringSync();
  final (data, body) = _parseFrontmatter(raw);
  if (data == null) return null;

  final title = data['title'] as String? ?? slug;
  final description = data['description'] as String? ?? '';
  final dateStr = data['date'] as String? ?? '';
  final date = DateTime.tryParse(dateStr) ?? DateTime.now();
  final rawTags = data['tags'];
  final tags = rawTags is YamlList ? rawTags.map((t) => t.toString()).toList() : <String>[];
  final image = data['image'] as String?;

  final htmlContent = _fixCodeBlockNewlines(
    md.markdownToHtml(body, extensionSet: md.ExtensionSet.gitHubWeb),
  );
  final wordCount = body.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  final readingTimeMinutes = (wordCount / 200).ceil().clamp(1, 999);

  return Post(
    meta: PostMeta(
      title: title,
      date: date,
      description: description,
      tags: tags,
      slug: slug,
      image: image,
    ),
    htmlContent: htmlContent,
    readingTimeMinutes: readingTimeMinutes,
  );
}

/// Replaces newlines inside `<pre><code>` blocks with `&#10;` HTML entities.
///
/// Jaspr's server-side HTML formatter indents every newline to match the
/// current component tree depth. Inside raw HTML from [RawText], that adds
/// unwanted spaces to every line after the first in code blocks. Using
/// `&#10;` instead of literal newlines avoids the indentation while the
/// browser still renders them as newlines inside `<pre>`.
String _fixCodeBlockNewlines(String html) {
  return html.replaceAllMapped(
    RegExp(r'<pre><code([^>]*)>([\s\S]*?)</code></pre>'),
    (match) {
      final attrs = match.group(1)!;
      final code = match.group(2)!.replaceAll('\n', '&#10;');
      return '<pre><code$attrs>$code</code></pre>';
    },
  );
}

/// Splits a markdown file into frontmatter data and body content.
///
/// Returns `(null, raw)` if no valid frontmatter block is found.
(YamlMap?, String) _parseFrontmatter(String raw) {
  if (!raw.startsWith('---')) return (null, raw);
  final end = raw.indexOf('\n---', 3);
  if (end == -1) return (null, raw);

  final yamlBlock = raw.substring(3, end).trim();
  final body = raw.substring(end + 4).trimLeft();

  try {
    final parsed = loadYaml(yamlBlock);
    if (parsed is YamlMap) return (parsed, body);
  } catch (_) {}

  return (null, raw);
}
