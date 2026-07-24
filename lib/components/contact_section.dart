import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class ContactSection extends StatelessComponent {
  const ContactSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(id: 'contact', classes: 'contact', [
      div(classes: 'contact__left', [
        h2(classes: 'contact__heading', [
          .text("Let's build"),
          br(),
          .text('something together'),
        ]),
        p(classes: 'contact__sub', [
          .text(
            'Open to collaboration and open-source work. '
            'Find me on LinkedIn, GitHub, or pub.dev.',
          ),
        ]),
        a(
          href: 'https://linkedin.com/in/andyjhorn',
          classes: 'contact__cta',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('Connect on LinkedIn')],
        ),
      ]),
      div(classes: 'contact__links', [
        a(
          href: 'https://linkedin.com/in/andyjhorn',
          classes: 'contact__link',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('linkedin.com/in/andyjhorn')],
        ),
        a(
          href: 'https://github.com/andyhorn',
          classes: 'contact__link',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('github.com/andyhorn')],
        ),
        a(
          href: 'https://pub.dev/publishers/andyhorn.dev',
          classes: 'contact__link',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('pub.dev/publishers/andyhorn.dev')],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact', [
      css('&').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .spaceBetween,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(120),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '80px'},
      ),
      css('.contact__left').styles(
        display: .flex,
        flexDirection: .column,
        alignItems: .start,
        raw: {'gap': '24px'},
      ),
      css('.contact__heading').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(56),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(560),
        raw: {'line-height': '1.05', 'letter-spacing': '-2px'},
      ),
      css('.contact__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(17),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(480),
        raw: {'line-height': '1.7'},
      ),
      css('.contact__cta').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        fontWeight: .w600,
        color: bgBase,
        backgroundColor: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(16),
          horizontal: Unit.pixels(32),
        ),
        raw: {
          'border-radius': '9999px',
          'text-decoration': 'none',
          'display': 'inline-flex',
          'align-items': 'center',
        },
      ),
      css('.contact__links').styles(
        display: .flex,
        flexDirection: .column,
        alignItems: .start,
        backgroundColor: bgSecondary,
        radius: .all(.circular(12.px)),
        padding: Spacing.all(Unit.pixels(28)),
        raw: {'gap': '18px', 'border': '1px solid #1A1A1A', 'flex-shrink': '0'},
      ),
      css('.contact__link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        color: textMuted,
        raw: {'text-decoration': 'none', 'transition': 'color 0.2s'},
      ),
      css('.contact__link:hover').styles(color: textPrimary),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.contact').styles(
        flexDirection: .column,
        alignItems: .start,
        padding: Spacing.symmetric(vertical: 60.px, horizontal: 24.px),
        raw: {'gap': '40px'},
      ),
      css('.contact .contact__heading').styles(
        raw: {'font-size': '36px', 'letter-spacing': '-1px'},
      ),
      css('.contact .contact__links').styles(
        raw: {'width': '100%'},
      ),
    ]),
  ];
}
