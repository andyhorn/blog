import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class BlogFilters extends StatelessComponent {
  const BlogFilters({super.key});

  static const _inactivePills = [
    'Flutter',
    'Dart',
    'Architecture',
    'Open Source',
    'DevX',
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog-filters', [
      span(classes: 'blog-filters__label', [.text('Filter:')]),
      span(classes: 'blog-filters__pill blog-filters__pill--active', [
        .text('All'),
      ]),
      for (final pill in _inactivePills) span(classes: 'blog-filters__pill', [.text(pill)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-filters', [
      css('&').styles(
        display: .flex,
        alignItems: .center,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(horizontal: Unit.pixels(120)),
        raw: {
          'height': '56px',
          'gap': '12px',
          'border-top': '1px solid #1A1A1A',
          'border-bottom': '1px solid #1A1A1A',
        },
      ),
      css('.blog-filters__label').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.blog-filters__pill').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
        backgroundColor: borderDefault,
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'height': '30px',
          'padding': '0 14px',
          'border-radius': '9999px',
          'border': '1px solid #2A2A2A',
        },
      ),
      css('.blog-filters__pill--active').styles(
        backgroundColor: accentPurple,
        color: bgBase,
        fontWeight: .w600,
        raw: {'border': 'none'},
      ),
    ]),
  ];
}
