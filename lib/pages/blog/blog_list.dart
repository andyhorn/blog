import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../components/blog_interactive_section.dart';
import '../../models/post.dart';

class BlogListPage extends StatelessComponent {
  const BlogListPage({required this.posts, super.key});

  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    final sorted = [...posts]..sort((x, y) => y.meta.date.compareTo(x.meta.date));

    return div([
      Document.head(
        title: 'Blog | Andy Horn',
        meta: {'description': 'Writing on Flutter, Dart, and software craft.'},
      ),
      BlogInteractiveSection(posts: sorted),
    ]);
  }

  @css
  static List<StyleRule> get styles => [];
}
