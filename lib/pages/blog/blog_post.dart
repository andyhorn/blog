import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../../constants/theme.dart';
import '../../models/post.dart';
import '../../utils/format_date.dart';
import '../../utils/tag_colors.dart';

class BlogPostPage extends StatelessComponent {
  const BlogPostPage({required this.post, super.key});

  final Post post;

  @override
  Component build(BuildContext context) {
    return div([
      Document.head(
        title: '${post.meta.title} | Andy Horn',
        meta: {
          'description': post.meta.description,
          'og:title': post.meta.title,
          'og:description': post.meta.description,
          'og:type': 'article',
          'og:url': 'https://andyhorn.dev/blog/${post.meta.slug}',
          'twitter:card': 'summary_large_image',
        },
      ),
      main_(classes: 'blog-post', [
        // Back link
        Link(
          to: '/blog',
          child: span(classes: 'blog-post__back-link', [.text('← Back to Blog')]),
        ),
        // Post header
        h1(classes: 'blog-post__title', [.text(post.meta.title)]),
        // Byline: date · reading time
        div(classes: 'blog-post__byline', [
          .text('${formatDate(post.meta.date)} · ${post.readingTimeMinutes} min read'),
        ]),
        // Tag pills
        if (post.meta.tags.isNotEmpty)
          div(classes: 'blog-post__tags', [
            for (final tag in post.meta.tags)
              span(
                classes: 'blog-post__tag',
                styles: Styles(
                  color: tagColor(tag),
                  backgroundColor: tagBgColor(tag),
                ),
                [.text(tag)],
              ),
          ]),
        // Content
        div(classes: 'blog-post__content', [RawText(post.htmlContent)]),
        // JSON-LD BlogPosting schema
        script(
          attributes: {'type': 'application/ld+json'},
          content: jsonEncode({
            '@context': 'https://schema.org',
            '@type': 'BlogPosting',
            'headline': post.meta.title,
            'description': post.meta.description,
            'datePublished': post.meta.date.toIso8601String(),
            'author': {
              '@type': 'Person',
              'name': 'Andy Horn',
              'url': 'https://andyhorn.dev',
            },
            'url': 'https://andyhorn.dev/blog/${post.meta.slug}',
          }),
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-post', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        maxWidth: Unit.pixels(800),
        margin: Spacing.symmetric(horizontal: Unit.auto),
        padding: Spacing.symmetric(
          vertical: Unit.pixels(64),
          horizontal: Unit.pixels(32),
        ),
        raw: {'gap': '24px'},
      ),
      css('.blog-post__back-link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        color: textMuted,
        raw: {'text-decoration': 'none', 'transition': 'color 0.2s'},
      ),
      css('.blog-post__back-link:hover').styles(color: textPrimary),
      css('.blog-post__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(40),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        raw: {'line-height': '1.15', 'letter-spacing': '-1px'},
      ),
      css('.blog-post__byline').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(13),
        color: textMuted,
      ),
      css('.blog-post__tags').styles(
        display: .flex,
        raw: {'gap': '8px', 'flex-wrap': 'wrap'},
      ),
      css('.blog-post__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(2),
          horizontal: Unit.pixels(8),
        ),
        raw: {'border-radius': '4px'},
      ),
      css('.blog-post__content', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
          raw: {'gap': '16px'},
        ),
        css('h1, h2, h3, h4, h5, h6').styles(
          fontFamily: fontGeist,
          color: textPrimary,
          fontWeight: .w700,
          margin: Spacing.zero,
        ),
        css('p').styles(
          fontFamily: fontInter,
          color: textMuted,
          margin: Spacing.zero,
          raw: {'line-height': '1.75'},
        ),
        css('a').styles(
          color: accentPurple,
          raw: {'text-decoration': 'underline'},
        ),
        css('code').styles(
          fontFamily: fontGeistMono,
          fontSize: Unit.pixels(14),
          backgroundColor: bgCard,
          raw: {'border-radius': '4px', 'padding': '2px 6px'},
        ),
        css('pre').styles(
          backgroundColor: bgCard,
          radius: .all(.circular(8.px)),
          padding: Spacing.all(Unit.pixels(24)),
          raw: {'border': '1px solid #1A1A1A', 'overflow-x': 'auto'},
        ),
        css('pre code').styles(
          raw: {'background': 'transparent', 'padding': '0'},
        ),
        css('ul, ol').styles(
          fontFamily: fontInter,
          color: textMuted,
          raw: {'line-height': '1.75', 'padding-left': '24px'},
        ),
        css('blockquote').styles(
          color: textMuted,
          padding: Spacing.only(left: Unit.pixels(16)),
          border: .only(
            left: .solid(color: accentPurple, width: 3.px),
          ),
          raw: {'font-style': 'italic'},
        ),
      ]),
    ]),
  ];
}
