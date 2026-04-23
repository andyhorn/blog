import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', [
      div(classes: 'hero__badge', [.text('Open to collaboration')]),
      h1(classes: 'hero__title', [
        .text('Flutter Engineer.'),
        br(),
        .text('Package Author.'),
        br(),
        .text('App Builder.'),
      ]),
      p(classes: 'hero__sub', [
        .text(
          '6+ years crafting high-quality Flutter apps and open-source packages. '
          'Focused on developer experience, clean architecture, and pixel-perfect UI.',
        ),
      ]),
      div(classes: 'hero__btns', [
        a(href: '/blog', classes: 'hero__btn hero__btn--secondary', [
          .text('Read the blog'),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        alignItems: .center,
        backgroundColor: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(80),
          horizontal: Unit.pixels(120),
        ),
        raw: {
          'min-height': '620px',
          'justify-content': 'center',
          'text-align': 'center',
        },
      ),
      css('.hero__badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: Colors.white,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(6),
          horizontal: Unit.pixels(16),
        ),
        raw: {
          'background': '#00000020',
          'border-radius': '9999px',
          'margin-bottom': '32px',
        },
      ),
      css('.hero__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(72),
        fontWeight: .w700,
        color: Colors.white,
        margin: Spacing.zero,
        raw: {
          'line-height': '1.05',
          'letter-spacing': '-2px',
          'margin-bottom': '24px',
        },
      ),
      css('.hero__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(18),
        margin: Spacing.zero,
        maxWidth: Unit.pixels(600),
        raw: {
          'color': '#FFFFFFCC',
          'line-height': '1.6',
          'margin-bottom': '40px',
        },
      ),
      css('.hero__btns').styles(
        display: .flex,
        raw: {'gap': '16px'},
      ),
      css('.hero__btn').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        fontWeight: .w600,
        color: Colors.white,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(14),
          horizontal: Unit.pixels(28),
        ),
        raw: {
          'border-radius': '9999px',
          'text-decoration': 'none',
          'display': 'inline-flex',
          'align-items': 'center',
        },
      ),
      css('.hero__btn--primary').styles(backgroundColor: bgBase),
      css('.hero__btn--secondary').styles(
        raw: {'background': '#FFFFFF20', 'border': '1px solid #FFFFFF40'},
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.hero').styles(
        padding: Spacing.symmetric(vertical: 60.px, horizontal: 24.px),
        raw: {'min-height': '360px'},
      ),
      css('.hero .hero__title').styles(
        raw: {'font-size': '48px', 'letter-spacing': '-1px'},
      ),
      css('.hero .hero__sub').styles(
        raw: {'font-size': '16px'},
      ),
      css('.hero .hero__btns').styles(
        flexDirection: .column,
        raw: {'width': '100%'},
      ),
      css('.hero .hero__btn').styles(
        raw: {'justify-content': 'center', 'text-align': 'center'},
      ),
    ]),
  ];
}
