import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import '../models/post.dart';
import 'blog_preview_card.dart';

class BlogPreviewSection extends StatelessComponent {
  const BlogPreviewSection({required this.posts, super.key});

  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    return section(classes: 'blog-preview', [
      div(classes: 'blog-preview__header', [
        div(classes: 'blog-preview__header-left', [
          span(classes: 'section-badge', [.text('// blog')]),
          h2(classes: 'section-heading', [.text('Latest Writing')]),
        ]),
        Link(
          to: '/blog',
          child: span(classes: 'blog-preview__all-link', [.text('All posts →')]),
        ),
      ]),
      if (posts.isEmpty)
        p(classes: 'blog-preview__empty', [.text('No posts yet — check back soon.')])
      else
        div(classes: 'blog-preview__grid', [
          for (final post in posts) BlogPreviewCard(post: post),
        ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-preview', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(100),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '48px'},
      ),
      css('.blog-preview__header').styles(
        display: .flex,
        justifyContent: .spaceBetween,
        raw: {'align-items': 'flex-end'},
      ),
      css('.blog-preview__header-left').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '16px'},
      ),
      css('.blog-preview__all-link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        fontWeight: .w600,
        color: textMuted,
        raw: {'text-decoration': 'none', 'transition': 'color 0.2s'},
      ),
      css('.blog-preview__all-link:hover').styles(color: textPrimary),
      css('.blog-preview__grid').styles(
        raw: {
          'display': 'grid',
          'grid-template-columns': 'repeat(3, 1fr)',
          'gap': '24px',
        },
      ),
      css('.blog-preview__empty').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(16),
        color: textMuted,
        margin: Spacing.zero,
      ),
    ]),
  ];
}
