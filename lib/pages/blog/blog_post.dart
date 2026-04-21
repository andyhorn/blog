import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../models/post.dart';

class BlogPostPage extends StatelessComponent {
  const BlogPostPage({required this.post, super.key});

  final Post post;

  @override
  Component build(BuildContext context) {
    return article([
      h1([.text(post.meta.title)]),
      div(classes: 'post-content', [
        RawText(post.htmlContent),
      ]),
    ]);
  }
}
