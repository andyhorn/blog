import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../utils/tag_colors.dart';

class BlogSidebar extends StatelessComponent {
  const BlogSidebar({super.key});

  static const _tags = [
    'Flutter',
    'Dart',
    'Architecture',
    'Open Source',
    'DevX',
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog-sidebar', [
      // About the author card
      div(classes: 'blog-sidebar__card', [
        span(classes: 'blog-sidebar__card-title', [.text('About the author')]),
        p(classes: 'blog-sidebar__bio', [
          .text(
            'Flutter engineer & package author. I write about building apps, open-source work, and the craft of software.',
          ),
        ]),
        div(classes: 'blog-sidebar__socials', [
          a(
            href: 'https://github.com/andyhorn',
            classes: 'blog-sidebar__social-icon',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [.text('GH')],
          ),
          a(
            href: 'https://linkedin.com/in/andyjhorn',
            classes: 'blog-sidebar__social-icon',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [.text('in')],
          ),
        ]),
      ]),
      // Topics card
      div(classes: 'blog-sidebar__card', [
        span(classes: 'blog-sidebar__card-title', [.text('Topics')]),
        div(classes: 'blog-sidebar__tags', [
          for (final tag in _tags)
            span(
              classes: 'blog-sidebar__tag',
              styles: Styles(
                color: tagColor(tag),
                backgroundColor: tagBgColor(tag),
              ),
              [.text(tag)],
            ),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-sidebar', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'width': '280px', 'gap': '24px', 'flex-shrink': '0'},
      ),
      css('.blog-sidebar__card').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        padding: Spacing.all(Unit.pixels(24)),
        radius: .all(.circular(8.px)),
        raw: {
          'border': '1px solid #1A1A1A',
          'gap': '16px',
        },
      ),
      css('.blog-sidebar__card-title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(14),
        fontWeight: .w700,
        color: textPrimary,
      ),
      css('.blog-sidebar__bio').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(13),
        color: textMuted,
        margin: Spacing.zero,
        raw: {'line-height': '1.6'},
      ),
      css('.blog-sidebar__socials').styles(
        display: .flex,
        raw: {'gap': '12px'},
      ),
      css('.blog-sidebar__social-icon').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        fontWeight: .w700,
        color: textMuted,
        backgroundColor: borderDefault,
        raw: {
          'width': '32px',
          'height': '32px',
          'border-radius': '9999px',
          'text-decoration': 'none',
        },
      ),
      css('.blog-sidebar__social-icon:hover').styles(color: textPrimary),
      css('.blog-sidebar__tags').styles(
        display: .flex,
        raw: {'gap': '8px', 'flex-wrap': 'wrap'},
      ),
      css('.blog-sidebar__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(4),
          horizontal: Unit.pixels(12),
        ),
        raw: {'border-radius': '9999px', 'display': 'inline-block'},
      ),
    ]),
  ];
}
