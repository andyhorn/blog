import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/header.dart';
import 'components/site_footer.dart';
import 'generated/post_routes.dart';
import 'pages/blog/blog_list.dart';
import 'pages/blog/blog_post.dart';
import 'pages/home.dart';
import 'services/post_service.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    final posts = loadAllPosts();

    return div(classes: 'main', [
      const Header(),
      Router(
        routes: [
          Route(
            path: '/',
            title: 'Andy Horn — Flutter Engineer & Package Author',
            builder: (context, state) => Home(recentPosts: posts.take(3).toList()),
          ),
          Route(
            path: '/blog',
            title: 'Blog',
            builder: (context, state) => BlogListPage(posts: posts),
          ),
          for (final slug in postSlugs)
            Route(
              path: '/blog/$slug',
              title: posts.firstWhere((post) => post.meta.slug == slug).meta.title,
              builder: (context, state) => BlogPostPage(
                post: posts.firstWhere((post) => post.meta.slug == slug),
              ),
            ),
        ],
      ),
      const SiteFooter(),
    ]);
  }

  // Defines the CSS styles for this component.
  //
  // By using the @css annotation, these will be rendered automatically to CSS and included in your page.
  // Must be a variable or getter of type [List<StyleRule>].
  @css
  static List<StyleRule> get styles => [
    css('.main').styles(
      display: .flex,
      flexDirection: .column,
    ),
  ];
}
