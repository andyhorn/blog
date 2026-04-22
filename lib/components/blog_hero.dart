import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class BlogHero extends StatelessComponent {
  const BlogHero({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog-hero', [
      span(classes: 'blog-hero__badge', [.text('// blog')]),
      h1(classes: 'blog-hero__title', [
        .text('Writing on Flutter,\nDart & Software Craft'),
      ]),
      p(classes: 'blog-hero__sub', [
        .text(
          'Thoughts on building apps, open-source packages, and the craft of software.',
        ),
      ]),
      // Visual-only search box — no <input>, static site
      div(classes: 'blog-hero__search', [
        span(classes: 'blog-hero__search-icon', [.text('🔍')]),
        span(classes: 'blog-hero__search-placeholder', [.text('Search posts…')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-hero', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(80),
          horizontal: Unit.pixels(120),
        ),
        raw: {
          'gap': '20px',
          'border-bottom': '1px solid #1A1A1A',
        },
      ),
      css('.blog-hero__badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(4),
          horizontal: Unit.pixels(10),
        ),
        raw: {
          'background': '#A855F715',
          'border-radius': '4px',
          'display': 'inline-block',
          'align-self': 'flex-start',
        },
      ),
      css('.blog-hero__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(56),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(800),
        raw: {
          'line-height': '1.05',
          'letter-spacing': '-2px',
          'white-space': 'pre-line',
        },
      ),
      css('.blog-hero__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(17),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(560),
        raw: {'line-height': '1.6'},
      ),
      css('.blog-hero__search').styles(
        display: .flex,
        alignItems: .center,
        maxWidth: Unit.pixels(560),
        raw: {
          'height': '52px',
          'background': '#111111',
          'border': '1px solid #2A2A2A',
          'border-radius': '8px',
          'gap': '12px',
          'padding': '0 20px',
        },
      ),
      css('.blog-hero__search-icon').styles(
        fontSize: Unit.pixels(18),
        color: textMuted,
      ),
      css('.blog-hero__search-placeholder').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        raw: {'color': '#3A3A3A'},
      ),
    ]),
  ];
}
