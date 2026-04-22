import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../components/blog_filters.dart';
import '../../components/blog_hero.dart';
import '../../components/blog_sidebar.dart';
import '../../components/featured_post_card.dart';
import '../../components/post_list_row.dart';
import '../../constants/theme.dart';
import '../../models/post.dart';

class BlogListPage extends StatelessComponent {
  const BlogListPage({required this.posts, super.key});

  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    final sorted = [...posts]..sort((x, y) => y.meta.date.compareTo(x.meta.date));
    final featured = sorted.isNotEmpty ? sorted.first : null;
    final rest = sorted.length > 1 ? sorted.skip(1).toList() : <Post>[];

    return div([
      Document.head(
        title: 'Blog | Andy Horn',
        meta: {'description': 'Writing on Flutter, Dart, and software craft.'},
      ),
      const BlogHero(),
      const BlogFilters(),
      featured != null
          ? _BlogBody(featured: featured, posts: rest)
          : div(classes: 'blog-empty', [
              p([.text('No posts yet — check back soon.')]),
            ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-empty').styles(
      padding: Spacing.symmetric(
        vertical: Unit.pixels(64),
        horizontal: Unit.pixels(120),
      ),
    ),
    css('.blog-body', [
      css('&').styles(
        display: .flex,
        flexDirection: .row,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(64),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '48px'},
      ),
      css('.blog-body__main').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'flex': '1', 'gap': '32px'},
      ),
      css('.blog-body__all-heading').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(22),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
      ),
      css('.blog-body__post-list').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        overflow: .clip,
        raw: {'border': '1px solid #1A1A1A', 'gap': '1px'},
      ),
      css('.blog-body__pagination').styles(
        display: .flex,
        justifyContent: .center,
        raw: {'gap': '8px'},
      ),
      css('.blog-body__page-btn').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(13),
        fontWeight: .w600,
        color: textMuted,
        backgroundColor: bgCard,
        radius: .all(.circular(6.px)),
        raw: {
          'height': '38px',
          'padding': '0 16px',
          'border': '1px solid #1A1A1A',
          'min-width': '38px',
        },
      ),
      css('.blog-body__page-btn--active').styles(
        backgroundColor: accentPurple,
        color: textPrimary,
        raw: {'border': 'none'},
      ),
    ]),
  ];
}

class _BlogBody extends StatelessComponent {
  const _BlogBody({required this.featured, required this.posts});

  final Post featured;
  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog-body', [
      div(classes: 'blog-body__main', [
        FeaturedPostCard(post: featured),
        if (posts.isNotEmpty) ...[
          h2(classes: 'blog-body__all-heading', [.text('All Posts')]),
          div(classes: 'blog-body__post-list', [
            for (final post in posts) PostListRow(post: post),
          ]),
          // Visual-only pagination — no interactivity in v1
          div(classes: 'blog-body__pagination', [
            span(classes: 'blog-body__page-btn', [.text('Prev')]),
            span(classes: 'blog-body__page-btn blog-body__page-btn--active', [
              .text('1'),
            ]),
            span(classes: 'blog-body__page-btn', [.text('2')]),
            span(classes: 'blog-body__page-btn', [.text('3')]),
            span(classes: 'blog-body__page-btn', [.text('Next')]),
          ]),
        ],
      ]),
      const BlogSidebar(),
    ]);
  }
}
