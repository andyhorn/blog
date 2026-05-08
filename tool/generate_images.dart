// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// Generates images for blog posts:
///
/// **Cover images** — posts with an [image_prompt] field in their frontmatter
/// but no [image] field yet get a 16:9 cover image saved to
/// [web/images/posts/<slug>.<ext>] and an [image:] field injected.
///
/// **Inline images** — any HTML comment in the post body matching:
///   <!-- image_prompt[name]: prompt text -->
///   <!-- image_prompt[name] ratio=4:3: prompt text -->
/// gets generated (default ratio 1:1), saved to
/// [web/images/posts/<slug>-<name>.<ext>], and a standard Markdown image tag
/// is inserted directly below the comment (the comment itself is preserved).
/// If the image file already exists on disk, generation is skipped.
///
/// Requires: GEMINI_API_KEY environment variable.
///
/// Run with: dart run tool/generate_images.dart
void main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Error: GEMINI_API_KEY environment variable not set.');
    exit(1);
  }

  final postsDir = Directory('content/posts');
  if (!postsDir.existsSync()) {
    print('No content/posts directory found.');
    return;
  }

  Directory('web/images/posts').createSync(recursive: true);

  final files = postsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.md')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var coverGenerated = 0;
  var coverSkipped = 0;
  var inlineGenerated = 0;

  for (final file in files) {
    final filename = file.uri.pathSegments.last;
    final slugMatch = RegExp(r'^\d{4}-\d{2}-\d{2}-(.+)\.md$').firstMatch(filename);
    if (slugMatch == null) continue;
    final slug = slugMatch.group(1)!;

    var raw = file.readAsStringSync();
    final data = _parseFrontmatter(raw);
    if (data == null) continue;

    // --- Cover image ---
    final existingCoverExt = ['png', 'jpg', 'webp'].firstWhere(
      (e) => File('web/images/posts/$slug.$e').existsSync(),
      orElse: () => '',
    );
    if (data['image'] != null || existingCoverExt.isNotEmpty) {
      print('[$slug] cover: already has image — skipping.');
      coverSkipped++;
    } else {
      final prompt = data['image_prompt'] as String?;
      if (prompt == null || prompt.isEmpty) {
        print('[$slug] cover: no image_prompt — skipping.');
        coverSkipped++;
      } else {
        print('[$slug] cover: generating "$prompt"');
        final result = await _generateImage(apiKey, prompt, aspectRatio: '16:9');
        if (result == null) {
          print('[$slug] cover: generation failed — skipping.');
        } else {
          final (imageBytes, mimeType) = result;
          final ext = _extForMime(mimeType);
          final assetPath = 'web/images/posts/$slug.$ext';
          final publicPath = '/images/posts/$slug.$ext';

          File(assetPath).writeAsBytesSync(imageBytes);
          print('[$slug] cover: saved $assetPath');

          raw = _injectImage(raw, publicPath);
          print('[$slug] cover: frontmatter updated with image: $publicPath');
          coverGenerated++;
        }
      }
    }

    // --- Inline images ---
    final (updatedRaw, count) = await _processInlineImages(apiKey, raw, slug);
    inlineGenerated += count;
    raw = updatedRaw;

    // Write once with all changes applied.
    file.writeAsStringSync(raw);
  }

  print(
    '\nDone — cover: $coverGenerated generated, $coverSkipped skipped; '
    'inline: $inlineGenerated generated.',
  );
}

/// Scans [raw] for inline image prompt comments, generates each image,
/// replaces the comment with an image tag, and returns the updated content
/// along with the number of images generated.
///
/// Syntax:
///   <!-- image_prompt[name]: prompt text -->
///   <!-- image_prompt[name] ratio=4:3: prompt text -->
///   <!-- image_prompt[name] width=300: prompt text -->
///   <!-- image_prompt[name] height=200: prompt text -->
///   <!-- image_prompt[name] ratio=4:3 width=300 height=200: prompt text -->
///
/// If [width] or [height] are set, outputs an `<img>` tag; otherwise outputs
/// standard Markdown `![]()` syntax.
Future<(String, int)> _processInlineImages(String apiKey, String raw, String slug) async {
  final pattern = RegExp(
    r'<!--\s*image_prompt\[(\w+)\]((?:\s+\w+=\S+)*)\s*:\s*(.+?)\s*-->',
  );

  var result = raw;
  var count = 0;

  for (final match in pattern.allMatches(raw)) {
    final name = match.group(1)!;
    final attrs = match.group(2) ?? '';
    final prompt = match.group(3)!;

    final ratio = RegExp(r'ratio=(\S+)').firstMatch(attrs)?.group(1) ?? '1:1';
    final width = RegExp(r'width=(\d+)').firstMatch(attrs)?.group(1);
    final height = RegExp(r'height=(\d+)').firstMatch(attrs)?.group(1);

    // Check for existing image (any supported extension).
    final existingExt = ['png', 'jpg', 'webp'].firstWhere(
      (e) => File('web/images/posts/$slug-$name.$e').existsSync(),
      orElse: () => '',
    );
    if (existingExt.isNotEmpty) {
      print('[$slug] inline[$name]: image already exists — skipping.');
      continue;
    }

    print('[$slug] inline[$name]: generating "$prompt"');
    final imageResult = await _generateImage(apiKey, prompt, aspectRatio: ratio);
    if (imageResult == null) {
      print('[$slug] inline[$name]: generation failed — skipping.');
      continue;
    }

    final (imageBytes, mimeType) = imageResult;
    final ext = _extForMime(mimeType);
    final assetPath = 'web/images/posts/$slug-$name.$ext';
    final publicPath = '/images/posts/$slug-$name.$ext';

    File(assetPath).writeAsBytesSync(imageBytes);
    print('[$slug] inline[$name]: saved $assetPath');

    // Keep the comment tag in place and insert the image below it.
    final tag = _imageTag(publicPath, width: width, height: height);
    result = result.replaceFirst(match.group(0)!, '${match.group(0)!}\n$tag');
    count++;
  }

  return (result, count);
}

/// Returns an `<img>` tag if [width] or [height] are set, otherwise a Markdown image.
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

/// Calls Imagen image generation and returns (imageBytes, mimeType), or null on failure.
///
/// Uses the Imagen `predict` endpoint which natively supports aspectRatio.
/// Note: if you get a 404, the model name may have changed since this was written.
/// Check https://ai.google.dev/api/images for the current model ID.
Future<(List<int>, String)?> _generateImage(
  String apiKey,
  String prompt, {
  String aspectRatio = '16:9',
}) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'imagen-4.0-fast-generate-001:predict'
      '?key=$apiKey',
    );

    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({
        'instances': [
          {'prompt': prompt},
        ],
        'parameters': {
          'sampleCount': 1,
          'aspectRatio': aspectRatio,
        },
      }),
    );

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      stderr.writeln('  API error ${response.statusCode}: $responseBody');
      return null;
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final predictions = json['predictions'] as List?;
    if (predictions == null || predictions.isEmpty) {
      stderr.writeln('  No predictions in response.');
      return null;
    }

    final prediction = predictions.first as Map;
    final encoded = prediction['bytesBase64Encoded'] as String?;
    if (encoded == null) {
      stderr.writeln('  No image data in response.');
      return null;
    }

    final mimeType = prediction['mimeType'] as String? ?? 'image/png';
    final bytes = base64Decode(encoded);
    return (bytes, mimeType);
  } finally {
    client.close();
  }
}

/// Maps a MIME type to a file extension.
String _extForMime(String mimeType) => switch (mimeType) {
  'image/jpeg' || 'image/jpg' => 'jpg',
  'image/webp' => 'webp',
  _ => 'png',
};

/// Inserts [image: "<path>"] into the YAML frontmatter of [raw].
String _injectImage(String raw, String imagePath) {
  if (!raw.startsWith('---')) return raw;
  final end = raw.indexOf('\n---', 3);
  if (end == -1) return raw;
  return '${raw.substring(0, end)}\nimage: "$imagePath"${raw.substring(end)}';
}

/// Parses the YAML frontmatter block from [raw], or returns null if absent.
YamlMap? _parseFrontmatter(String raw) {
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
