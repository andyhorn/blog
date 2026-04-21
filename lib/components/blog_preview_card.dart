import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/post.dart';
import '../utils/tag_colors.dart';

class BlogPreviewCard extends StatelessComponent {
  const BlogPreviewCard({required this.post, super.key});

  final Post post;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get _formattedDate {
    final d = post.meta.date;
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Component build(BuildContext context) {
    final firstTag = post.meta.tags.isNotEmpty ? post.meta.tags.first : null;

    return a(
      href: '/blog/${post.meta.slug}',
      classes: 'blog-preview-card',
      [
        // Meta row: date | divider | tag pill
        div(classes: 'blog-preview-card__meta', [
          span(classes: 'blog-preview-card__date', [.text(_formattedDate)]),
          if (firstTag != null) ...[
            div(classes: 'blog-preview-card__divider', []),
            span(
              classes: 'blog-preview-card__tag',
              styles: Styles(
                color: tagColor(firstTag),
                backgroundColor: tagBgColor(firstTag),
              ),
              [.text(firstTag)],
            ),
          ],
        ]),
        // Title
        h3(classes: 'blog-preview-card__title', [.text(post.meta.title)]),
        // Excerpt
        p(
          classes: 'blog-preview-card__excerpt',
          [.text(post.meta.description)],
        ),
        // Read more
        span(classes: 'blog-preview-card__read-more', [.text('Read more →')]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-preview-card', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        padding: Spacing.all(Unit.pixels(32)),
        color: textPrimary,
        raw: {
          'border': '1px solid #1A1A1A',
          'gap': '20px',
          'text-decoration': 'none',
        },
      ),
      css('&:hover .blog-preview-card__title').styles(color: accentPurple),
      css('.blog-preview-card__meta').styles(
        display: .flex,
        alignItems: .center,
        raw: {'gap': '12px'},
      ),
      css('.blog-preview-card__date').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.blog-preview-card__divider').styles(
        width: Unit.pixels(1),
        backgroundColor: borderDefault,
        raw: {'height': '12px', 'flex-shrink': '0'},
      ),
      css('.blog-preview-card__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(2),
          horizontal: Unit.pixels(8),
        ),
        raw: {'border-radius': '4px'},
      ),
      css('.blog-preview-card__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(20),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(340),
        raw: {'line-height': '1.3', 'transition': 'color 0.2s'},
      ),
      css('.blog-preview-card__excerpt').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        color: textMuted,
        margin: Spacing.zero,
        raw: {'line-height': '1.6'},
      ),
      css('.blog-preview-card__read-more').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        fontWeight: .w600,
        color: accentPurple,
        raw: {'margin-top': 'auto'},
      ),
    ]),
  ];
}
