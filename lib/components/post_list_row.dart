import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/post.dart';
import '../utils/format_date.dart';
import '../utils/tag_colors.dart';

class PostListRow extends StatelessComponent {
  const PostListRow({required this.post, super.key});

  final Post post;

  @override
  Component build(BuildContext context) {
    return a(
      href: '/blog/${post.meta.slug}',
      classes: 'post-list-row',
      [
        // Left side
        div(classes: 'post-list-row__left', [
          if (post.meta.tags.isNotEmpty)
            div(classes: 'post-list-row__tags', [
              for (final tag in post.meta.tags)
                span(
                  classes: 'post-list-row__tag',
                  styles: Styles(
                    color: tagColor(tag),
                    backgroundColor: tagBgColor(tag),
                  ),
                  [.text(tag)],
                ),
            ]),
          span(classes: 'post-list-row__title', [.text(post.meta.title)]),
        ]),
        // Right side
        div(classes: 'post-list-row__right', [
          span(classes: 'post-list-row__date', [
            .text(formatDate(post.meta.date)),
          ]),
          span(classes: 'post-list-row__reading-time', [
            .text('${post.readingTimeMinutes} min read'),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.post-list-row', [
      css('&').styles(
        display: .flex,
        flexDirection: .row,
        alignItems: .center,
        backgroundColor: bgBase,
        color: textPrimary,
        padding: Spacing.symmetric(horizontal: Unit.pixels(24)),
        raw: {
          'height': '88px',
          'gap': '16px',
          'text-decoration': 'none',
        },
      ),
      css('&:hover .post-list-row__title').styles(color: accentPurple),
      css('.post-list-row__left').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'flex': '1', 'gap': '4px'},
      ),
      css('.post-list-row__tags').styles(
        display: .flex,
        raw: {'gap': '8px'},
      ),
      css('.post-list-row__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(10),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(2),
          horizontal: Unit.pixels(6),
        ),
        raw: {
          'border-radius': '4px',
          'height': '20px',
          'display': 'inline-flex',
          'align-items': 'center',
        },
      ),
      css('.post-list-row__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(16),
        fontWeight: .w600,
        color: textPrimary,
        raw: {'transition': 'color 0.2s'},
      ),
      css('.post-list-row__right').styles(
        display: .flex,
        flexDirection: .column,
        alignItems: .end,
        raw: {'gap': '4px'},
      ),
      css('.post-list-row__date').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.post-list-row__reading-time').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
    ]),
  ];
}
