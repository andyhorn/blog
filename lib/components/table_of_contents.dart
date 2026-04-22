import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../utils/headings.dart';

class TableOfContents extends StatelessComponent {
  const TableOfContents({required this.items, required this.basePath, super.key});

  final List<TocItem> items;

  /// The path of the current page, e.g. `/blog/my-post`.
  /// Used to construct full anchor URLs so jaspr_router doesn't intercept them.
  final String basePath;

  @override
  Component build(BuildContext context) {
    return nav(classes: 'toc', [
      span(classes: 'toc__title', [.text('On this page')]),
      div(classes: 'toc__divider', []),
      for (final item in items)
        a(
          href: '$basePath#${item.id}',
          classes: 'toc__item',
          [
            div(classes: 'toc__bar', []),
            span(classes: 'toc__text', [.text(item.text)]),
          ],
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.toc', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        raw: {
          'gap': '8px',
          'border': '1px solid #1A1A1A',
          'padding': '24px',
          'width': '260px',
        },
      ),
      css('.toc__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(13),
        fontWeight: .w700,
        color: textPrimary,
        raw: {'letter-spacing': '0.5px'},
      ),
      css('.toc__divider').styles(
        raw: {'background': '#1A1A1A', 'height': '1px'},
      ),
      css('.toc__item').styles(
        display: .flex,
        alignItems: .center,
        raw: {
          'gap': '10px',
          'height': '32px',
          'text-decoration': 'none',
        },
      ),
      css('.toc__bar').styles(
        raw: {
          'width': '2px',
          'height': '20px',
          'border-radius': '1px',
          'background': '#2A2A2A',
          'transition': 'background 0.2s',
          'flex-shrink': '0',
        },
      ),
      css('.toc__text').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(13),
        color: textMuted,
        raw: {'transition': 'color 0.2s'},
      ),
      css('.toc__item:hover .toc__bar').styles(
        raw: {'background': '#A855F7'},
      ),
      css('.toc__item:hover .toc__text').styles(
        color: textPrimary,
      ),
    ]),
  ];
}
