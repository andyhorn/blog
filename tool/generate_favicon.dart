// ignore_for_file: avoid_print
import 'dart:io';

/// Generates a favicon using the Geist Bold font and ImageMagick.
///
/// Renders a "</>" code symbol in purple (#A855F7) on near-black (#0A0A0A),
/// and outputs:
///   web/favicon.png
///   web/favicon.ico
///
/// Requires: ImageMagick (brew install imagemagick)
///
/// Run with: dart run tool/generate_favicon.dart
void main() async {
  final magick = await _findExecutable(['magick']);
  if (magick == null) {
    stderr.writeln('Error: ImageMagick not found. Run: brew install imagemagick');
    exit(1);
  }

  // Locate Geist Bold — check common install locations.
  final home = Platform.environment['HOME'];
  final fontPath =
      [
        // brew install --cask font-geist
        '$home/Library/Fonts/Geist-Bold.otf',
        '$home/Library/Fonts/Geist-Bold.ttf',
        '/Library/Fonts/Geist-Bold.otf',
        '/Library/Fonts/Geist-Bold.ttf',
      ].cast<String?>().firstWhere(
        (p) => p != null && File(p).existsSync(),
        orElse: () => null,
      );

  if (fontPath == null) {
    stderr.writeln('Geist Bold not found. Install it with:');
    stderr.writeln('  brew install --cask font-geist');
    exit(1);
  }
  print('Using font: $fontPath');

  const size = 512;
  const pngPath = 'web/favicon.png';

  print('Rendering favicon...');
  final renderResult = await Process.run(magick, [
    '-size',
    '${size}x$size',
    'xc:none',
    '-font',
    fontPath,
    '-pointsize',
    '310',
    '-fill',
    '#A855F7',
    '-gravity',
    'Center',
    '-annotate',
    '0',
    '</>',
    pngPath,
  ]);

  if (renderResult.exitCode != 0) {
    stderr.writeln('Render failed: ${renderResult.stderr}');
    exit(1);
  }
  print('Saved $pngPath');

  print('Converting to favicon.ico...');
  final icoResult = await Process.run(magick, [
    pngPath,
    '-define',
    'icon:auto-resize=256,128,64,48,32,16',
    'web/favicon.ico',
  ]);

  if (icoResult.exitCode != 0) {
    stderr.writeln('ICO conversion failed: ${icoResult.stderr}');
  } else {
    print('Saved web/favicon.ico');
  }

  print('\nDone.');
}

/// Returns the path to the first executable found in PATH, or null.
Future<String?> _findExecutable(List<String> candidates) async {
  for (final name in candidates) {
    try {
      final result = await Process.run('which', [name]);
      if (result.exitCode == 0) return (result.stdout as String).trim();
    } catch (_) {}
  }
  return null;
}
