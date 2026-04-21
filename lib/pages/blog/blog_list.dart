import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../models/post.dart';

class BlogListPage extends StatelessComponent {
  const BlogListPage({required this.posts, super.key});

  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    return section([
      h1([.text('Blog')]),
      if (posts.isEmpty)
        p([.text('No posts yet — check back soon.')])
      else
        for (final post in posts)
          article([
            h2([.text(post.meta.title)]),
          ]),
    ]);
  }
}
