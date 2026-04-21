// ignore_for_file: avoid_print
import 'dart:io';

/// Scans [content/posts/] for markdown files and emits
/// [lib/generated/post_routes.dart] with a list of post slugs.
///
/// Run with: dart run tool/generate_routes.dart
void main() {
  final dir = Directory('content/posts');
  if (!dir.existsSync()) {
    print('No content/posts directory found — writing empty slug list.');
  }

  final slugPattern = RegExp(r'^\d{4}-\d{2}-\d{2}-(.+)\.md$');

  final slugs = <String>[];
  if (dir.existsSync()) {
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.md')).toList()
      ..sort((a, b) => b.path.compareTo(a.path)); // newest-first

    for (final file in files) {
      final filename = file.uri.pathSegments.last;
      final match = slugPattern.firstMatch(filename);
      if (match != null) slugs.add(match.group(1)!);
    }
  }

  final lines = slugs.map((s) => "  '$s',").join('\n');
  final output =
      '''// GENERATED — do not edit by hand. Run: dart run tool/generate_routes.dart
const List<String> postSlugs = [
$lines
];
''';

  final outFile = File('lib/generated/post_routes.dart');
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(output);
  print('Wrote ${slugs.length} slug(s) to ${outFile.path}');
}
