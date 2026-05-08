// ignore_for_file: avoid_print
import 'dart:io';

import 'src/image_api.dart';

/// Generates a single image from a prompt and writes it to disk.
///
/// Requires: GEMINI_API_KEY environment variable.
///
/// Usage:
///   dart run tool/generate_image.dart \
///     --prompt "a friendly robot" \
///     --output web/images/posts/hello.png \
///     [--ratio 16:9]
///
/// `--output` is the desired path. The actual saved file's extension is
/// replaced with the one matching the API's returned MIME type
/// (png/jpg/webp), and the final path is printed to stdout.
Future<void> main(List<String> argv) async {
  final args = _parseArgs(argv);
  final prompt = args['prompt'];
  final output = args['output'];
  final ratio = args['ratio'] ?? '16:9';

  if (prompt == null || prompt.isEmpty || output == null || output.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/generate_image.dart '
      '--prompt "..." --output <path> [--ratio 16:9]',
    );
    exit(64);
  }

  final apiKey = requireApiKey();

  print('Generating "$prompt" (ratio $ratio)…');
  final image = await generateImage(apiKey, prompt, aspectRatio: ratio);
  if (image == null) {
    stderr.writeln('Generation failed.');
    exit(1);
  }

  final dot = output.lastIndexOf('.');
  final base = dot == -1 ? output : output.substring(0, dot);
  final finalPath = '$base.${image.extension}';

  Directory(File(finalPath).parent.path).createSync(recursive: true);
  File(finalPath).writeAsBytesSync(image.bytes);
  print('Saved $finalPath');
}

Map<String, String> _parseArgs(List<String> argv) {
  final out = <String, String>{};
  for (var i = 0; i < argv.length; i++) {
    final a = argv[i];
    if (a.startsWith('--') && i + 1 < argv.length) {
      out[a.substring(2)] = argv[++i];
    }
  }
  return out;
}
