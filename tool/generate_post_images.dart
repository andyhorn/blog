// ignore_for_file: avoid_print
import 'dart:io';

import 'src/image_api.dart';
import 'src/post_images.dart';

const _imagesDir = 'web/images/posts';

/// Finds every blog post image that has a prompt but no file on disk,
/// generates each one via the Imagen API, saves it under [_imagesDir],
/// and updates the post's frontmatter (cover) or body (inline).
///
/// Requires: GEMINI_API_KEY environment variable.
///
/// Run with: dart run tool/generate_post_images.dart [--quality fast|standard|ultra|gemini]
Future<void> main(List<String> argv) async {
  final quality = ImageQuality.parse(_argValue(argv, '--quality') ?? 'fast');
  final apiKey = requireApiKey();
  print('Using quality: ${quality.name}\n');
  Directory(_imagesDir).createSync(recursive: true);

  final missing = findMissingImages(imagesDir: _imagesDir);
  if (missing.isEmpty) {
    print('Nothing to do — all requested images already exist.');
    return;
  }

  print('Generating ${missing.length} image(s)…\n');

  // Group by slug so we only read+write each post file once.
  final bySlug = <String, List<MissingImage>>{};
  for (final m in missing) {
    bySlug.putIfAbsent(m.slug, () => []).add(m);
  }

  var generated = 0;
  var failed = 0;

  for (final entry in bySlug.entries) {
    final slug = entry.key;
    final file = findPostFileForSlug(slug);
    if (file == null) {
      stderr.writeln('[$slug] post file not found — skipping.');
      failed += entry.value.length;
      continue;
    }

    var raw = file.readAsStringSync();

    for (final m in entry.value) {
      print('${m.label}: generating "${m.prompt}"');
      final image = await generateImage(
        apiKey,
        m.prompt,
        aspectRatio: m.aspectRatio,
        quality: quality,
      );
      if (image == null) {
        stderr.writeln('${m.label}: generation failed.');
        failed++;
        continue;
      }

      final assetPath = '${m.assetPathWithoutExt(_imagesDir)}.${image.extension}';
      final publicPath = '${m.publicPathWithoutExt()}.${image.extension}';
      File(assetPath).writeAsBytesSync(image.bytes);
      print('${m.label}: saved $assetPath');

      raw = switch (m) {
        MissingCoverImage() => injectCoverImage(raw, publicPath),
        MissingInlineImage(:final commentTag, :final width, :final height) => injectInlineImage(
          raw,
          commentTag,
          publicPath,
          width: width,
          height: height,
        ),
      };
      generated++;
    }

    file.writeAsStringSync(raw);
  }

  print('\nDone — $generated generated, $failed failed.');
}

String? _argValue(List<String> argv, String flag) {
  for (var i = 0; i < argv.length - 1; i++) {
    if (argv[i] == flag) return argv[i + 1];
  }
  return null;
}
