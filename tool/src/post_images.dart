// ignore_for_file: avoid_print
import 'dart:io';

import 'package:yaml/yaml.dart';

/// A single image that a post has requested but doesn't yet have on disk.
sealed class MissingImage {
  MissingImage(this.slug, this.prompt, this.aspectRatio);

  /// Post slug (filename without date prefix and `.md`).
  final String slug;

  /// The prompt taken from the post (frontmatter or inline comment).
  final String prompt;

  /// Aspect ratio to request from the API.
  final String aspectRatio;

  /// Path on disk where the image should be saved (no extension).
  String assetPathWithoutExt(String dir) => '$dir/$_basename';

  /// Public URL path used inside the post (no extension).
  String publicPathWithoutExt() => '/images/posts/$_basename';

  String get _basename;

  /// Human-readable single-line summary, e.g. `[swift-firebase-bug] cover`.
  String get label;
}

class MissingCoverImage extends MissingImage {
  MissingCoverImage({required String slug, required String prompt})
    : super(slug, prompt, '16:9');

  @override
  String get _basename => slug;

  @override
  String get label => '[$slug] cover';
}

class MissingInlineImage extends MissingImage {
  MissingInlineImage({
    required String slug,
    required String prompt,
    required String aspectRatio,
    required this.name,
    required this.commentTag,
    required this.width,
    required this.height,
  }) : super(slug, prompt, aspectRatio);

  /// Name from the inline comment (`<!-- image_prompt[name]: ... -->`).
  final String name;

  /// The full comment string as it appears in the post body. Used to splice
  /// the generated image tag back in beneath it.
  final String commentTag;

  final String? width;
  final String? height;

  @override
  String get _basename => '$slug-$name';

  @override
  String get label => '[$slug] inline[$name]';
}

/// Scans every Markdown file under [postsDir], compares each post's prompts
/// against any images already present in [imagesDir], and returns the list
/// of [MissingImage]s that still need to be generated.
List<MissingImage> findMissingImages({
  String postsDir = 'content/posts',
  String imagesDir = 'web/images/posts',
}) {
  final dir = Directory(postsDir);
  if (!dir.existsSync()) return const [];

  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final missing = <MissingImage>[];

  for (final file in files) {
    final filename = file.uri.pathSegments.last;
    final slugMatch = RegExp(
      r'^\d{4}-\d{2}-\d{2}-(.+)\.md$',
    ).firstMatch(filename);
    if (slugMatch == null) continue;
    final slug = slugMatch.group(1)!;

    final raw = file.readAsStringSync();
    final fm = parseFrontmatter(raw);
    if (fm == null) continue;

    // Cover.
    final coverPrompt = fm['image_prompt'] as String?;
    final hasCoverField = fm['image'] != null;
    final hasCoverFile = _imageExists(imagesDir, slug);
    if (coverPrompt != null &&
        coverPrompt.isNotEmpty &&
        !hasCoverField &&
        !hasCoverFile) {
      missing.add(MissingCoverImage(slug: slug, prompt: coverPrompt));
    }

    // Inline.
    for (final inline in _findInlinePrompts(raw)) {
      if (_imageExists(imagesDir, '$slug-${inline.name}')) continue;
      missing.add(
        MissingInlineImage(
          slug: slug,
          name: inline.name,
          prompt: inline.prompt,
          aspectRatio: inline.ratio,
          width: inline.width,
          height: inline.height,
          commentTag: inline.commentTag,
        ),
      );
    }
  }

  return missing;
}

/// Returns true if a `<basename>.{png,jpg,webp}` exists under [dir].
bool _imageExists(String dir, String basename) {
  return [
    'png',
    'jpg',
    'webp',
  ].any((e) => File('$dir/$basename.$e').existsSync());
}

class _InlinePrompt {
  _InlinePrompt({
    required this.name,
    required this.prompt,
    required this.ratio,
    required this.width,
    required this.height,
    required this.commentTag,
  });

  final String name;
  final String prompt;
  final String ratio;
  final String? width;
  final String? height;
  final String commentTag;
}

/// Inline comment syntax:
///   <!-- image_prompt[name]: prompt text -->
///   <!-- image_prompt[name] ratio=4:3 width=300 height=200: prompt text -->
Iterable<_InlinePrompt> _findInlinePrompts(String raw) sync* {
  final pattern = RegExp(
    r'<!--\s*image_prompt\[(\w+)\]((?:\s+\w+=\S+)*)\s*:\s*(.+?)\s*-->',
  );

  for (final m in pattern.allMatches(raw)) {
    final attrs = m.group(2) ?? '';
    yield _InlinePrompt(
      name: m.group(1)!,
      prompt: m.group(3)!,
      ratio: RegExp(r'ratio=(\S+)').firstMatch(attrs)?.group(1) ?? '1:1',
      width: RegExp(r'width=(\d+)').firstMatch(attrs)?.group(1),
      height: RegExp(r'height=(\d+)').firstMatch(attrs)?.group(1),
      commentTag: m.group(0)!,
    );
  }
}

/// Returns the path to the Markdown file for [slug], or null if not found.
File? findPostFileForSlug(String slug, {String postsDir = 'content/posts'}) {
  final dir = Directory(postsDir);
  if (!dir.existsSync()) return null;
  for (final file in dir.listSync().whereType<File>()) {
    final filename = file.uri.pathSegments.last;
    final m = RegExp(r'^\d{4}-\d{2}-\d{2}-(.+)\.md$').firstMatch(filename);
    if (m != null && m.group(1) == slug) return file;
  }
  return null;
}

/// Inserts `image: "<path>"` into the YAML frontmatter of [raw].
String injectCoverImage(String raw, String imagePath) {
  if (!raw.startsWith('---')) return raw;
  final end = raw.indexOf('\n---', 3);
  if (end == -1) return raw;
  return '${raw.substring(0, end)}\nimage: "$imagePath"${raw.substring(end)}';
}

/// Inserts a Markdown/HTML image tag below an inline `image_prompt` comment.
String injectInlineImage(
  String raw,
  String commentTag,
  String publicPath, {
  String? width,
  String? height,
}) {
  return raw.replaceFirst(
    commentTag,
    '$commentTag\n${_imageTag(publicPath, width: width, height: height)}',
  );
}

String _imageTag(String path, {String? width, String? height}) {
  if (width != null || height != null) {
    final parts = [
      'src="$path"',
      if (width != null) 'width="$width"',
      if (height != null) 'height="$height"',
    ];
    return '<img ${parts.join(' ')} />';
  }
  return '![]($path)';
}

/// Parses the YAML frontmatter block at the top of [raw], or null if absent.
YamlMap? parseFrontmatter(String raw) {
  if (!raw.startsWith('---')) return null;
  final end = raw.indexOf('\n---', 3);
  if (end == -1) return null;
  try {
    final parsed = loadYaml(raw.substring(3, end).trim());
    return parsed is YamlMap ? parsed : null;
  } catch (_) {
    return null;
  }
}
