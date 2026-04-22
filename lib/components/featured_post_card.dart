import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/post.dart';
import '../utils/format_date.dart';
import '../utils/tag_colors.dart';

class FeaturedPostCard extends StatelessComponent {
  const FeaturedPostCard({required this.post, super.key});

  final Post post;

  @override
  Component build(BuildContext context) {
    final firstTag = post.meta.tags.isNotEmpty ? post.meta.tags.first : null;

    return a(
      href: '/blog/${post.meta.slug}',
      classes: 'featured-post-card',
      [
        // Left image
        if (post.meta.image != null)
          img(
            src: post.meta.image!,
            alt: post.meta.title,
            classes: 'featured-post-card__image',
          )
        else
          div(classes: 'featured-post-card__image', []),
        // Right content
        div(classes: 'featured-post-card__content', [
          // Meta row
          div(classes: 'featured-post-card__meta', [
            if (firstTag != null)
              span(
                classes: 'featured-post-card__tag',
                styles: Styles(
                  color: tagColor(firstTag),
                  backgroundColor: tagBgColor(firstTag),
                ),
                [.text(firstTag)],
              ),
            span(classes: 'featured-post-card__featured-badge', [
              .text('★ Featured'),
            ]),
            span(classes: 'featured-post-card__date', [
              .text(formatDate(post.meta.date)),
            ]),
            span(classes: 'featured-post-card__reading-time', [
              .text('${post.readingTimeMinutes} min read'),
            ]),
          ]),
          // Title
          h2(classes: 'featured-post-card__title', [.text(post.meta.title)]),
          // Excerpt
          p(classes: 'featured-post-card__excerpt', [
            .text(post.meta.description),
          ]),
          // Read post link
          span(classes: 'featured-post-card__read-link', [
            .text('Read post →'),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured-post-card', [
      css('&').styles(
        display: .flex,
        flexDirection: .row,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        overflow: .clip,
        color: textPrimary,
        raw: {'border': '1px solid #1A1A1A', 'text-decoration': 'none'},
      ),
      css('&:hover .featured-post-card__title').styles(color: accentPurple),
      css('.featured-post-card__image').styles(
        backgroundColor: Color('#A855F710'),
        raw: {
          'width': '436px',
          'height': '315px',
          'flex-shrink': '0',
          'object-fit': 'cover',
          'display': 'block',
        },
      ),
      css('.featured-post-card__content').styles(
        display: .flex,
        flexDirection: .column,
        padding: Spacing.all(Unit.pixels(32)),
        raw: {'gap': '16px', 'flex': '1'},
      ),
      css('.featured-post-card__meta').styles(
        display: .flex,
        alignItems: .center,
        raw: {'gap': '12px'},
      ),
      css('.featured-post-card__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(2),
          horizontal: Unit.pixels(8),
        ),
        raw: {'border-radius': '4px'},
      ),
      css('.featured-post-card__featured-badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(10),
        raw: {
          'color': '#F59E0B',
          'background': '#F59E0B20',
          'border-radius': '4px',
          'height': '24px',
          'padding': '0 10px',
          'display': 'inline-flex',
          'align-items': 'center',
        },
      ),
      css('.featured-post-card__date').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.featured-post-card__reading-time').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.featured-post-card__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(26),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        raw: {'line-height': '1.2', 'transition': 'color 0.2s'},
      ),
      css('.featured-post-card__excerpt').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        color: textMuted,
        margin: Spacing.zero,
        raw: {'line-height': '1.65'},
      ),
      css('.featured-post-card__read-link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        fontWeight: .w600,
        color: accentPurple,
        raw: {'margin-top': 'auto'},
      ),
    ]),
  ];
}
