import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', [
      h1(classes: 'hero__title', [
        span(classes: 'hero__title-line', [.text('I build Flutter apps')]),
        span(classes: 'hero__title-line hero__title-line--accent', [
          .text('and the open-source'),
        ]),
        span(classes: 'hero__title-line hero__title-line--accent', [
          .text('packages behind them.'),
        ]),
      ]),
      p(classes: 'hero__sub', [
        .text(
          'Six years shipping polished mobile apps and the Dart packages that '
          'power them. Published on pub.dev, live on the App Store.',
        ),
      ]),
      div(classes: 'hero__btns', [
        a(href: '/blog', classes: 'hero__btn hero__btn--primary', [
          .text('Read the blog'),
        ]),
        a(href: '/#packages', classes: 'hero__btn hero__btn--secondary', [
          .text('View packages'),
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
        alignItems: .start,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(80),
          horizontal: Unit.pixels(120),
        ),
        raw: {
          'min-height': '620px',
          'justify-content': 'center',
          'text-align': 'left',
        },
      ),
      css('.hero__title').styles(
        display: .flex,
        flexDirection: .column,
        fontFamily: fontGeist,
        fontSize: Unit.pixels(68),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(820),
        raw: {
          'line-height': '1.05',
          'letter-spacing': '-2.5px',
          'margin-bottom': '32px',
        },
      ),
      css('.hero__title-line--accent').styles(color: accentPurple),
      css('.hero__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(18),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(560),
        raw: {
          'line-height': '1.6',
          'margin-bottom': '40px',
        },
      ),
      css('.hero__btns').styles(
        display: .flex,
        raw: {'gap': '14px'},
      ),
      css('.hero__btn').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        fontWeight: .w600,
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
      css('.hero__btn--primary').styles(
        color: bgBase,
        backgroundColor: accentPurple,
      ),
      css('.hero__btn--secondary').styles(
        color: textPrimary,
        raw: {'background': 'transparent', 'border': '1px solid #FFFFFF26'},
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
