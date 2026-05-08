// ignore_for_file: avoid_print
import 'src/post_images.dart';

/// Lists every blog-post image (cover or inline) that has a prompt but no
/// matching file under `web/images/posts/`.
///
/// Output format (one entry per line):
///   `[slug] kind  ratio=R  prompt="..."`
///
/// Run with: dart run tool/find_posts_without_images.dart
void main() {
  final missing = findMissingImages();

  if (missing.isEmpty) {
    print('All posts have their requested images.');
    return;
  }

  for (final m in missing) {
    print('${m.label}  ratio=${m.aspectRatio}  prompt="${m.prompt}"');
  }

  print('\n${missing.length} image(s) missing.');
}
