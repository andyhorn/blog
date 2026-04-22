// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// Generates cover images for blog posts that have an [image_prompt] field
/// in their frontmatter but no [image] field yet.
///
/// Calls Gemini's image generation API, saves the result to
/// [web/images/posts/<slug>.<ext>], and rewrites the post's frontmatter
/// to set [image: "/images/posts/<slug>.<ext>"].
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

  var generated = 0;
  var skipped = 0;

  for (final file in files) {
    final filename = file.uri.pathSegments.last;
    final slugMatch = RegExp(r'^\d{4}-\d{2}-\d{2}-(.+)\.md$').firstMatch(filename);
    if (slugMatch == null) continue;
    final slug = slugMatch.group(1)!;

    final raw = file.readAsStringSync();
    final data = _parseFrontmatter(raw);
    if (data == null) continue;

    if (data['image'] != null) {
      print('[$slug] already has image — skipping.');
      skipped++;
      continue;
    }

    final prompt = data['image_prompt'] as String?;
    if (prompt == null || prompt.isEmpty) {
      print('[$slug] no image_prompt — skipping.');
      skipped++;
      continue;
    }

    print('[$slug] generating: "$prompt"');
    final result = await _generateImage(apiKey, prompt);
    if (result == null) {
      print('[$slug] generation failed — skipping.');
      continue;
    }

    final (imageBytes, mimeType) = result;
    final ext = _extForMime(mimeType);
    final assetPath = 'web/images/posts/$slug.$ext';
    final publicPath = '/images/posts/$slug.$ext';

    File(assetPath).writeAsBytesSync(imageBytes);
    print('[$slug] saved $assetPath');

    file.writeAsStringSync(_injectImage(raw, publicPath));
    print('[$slug] frontmatter updated with image: $publicPath');
    generated++;
  }

  print('\nDone — generated: $generated, skipped: $skipped.');
}

/// Calls Imagen image generation and returns (imageBytes, mimeType), or null on failure.
///
/// Uses the Imagen `predict` endpoint which natively supports aspectRatio.
/// Note: if you get a 404, the model name may have changed since this was written.
/// Check https://ai.google.dev/api/images for the current model ID.
Future<(List<int>, String)?> _generateImage(String apiKey, String prompt) async {
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
          'aspectRatio': '16:9',
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
