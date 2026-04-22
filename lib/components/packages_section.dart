import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/packages.dart';
import 'package_card.dart';

class PackagesSection extends StatelessComponent {
  const PackagesSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(id: 'packages', classes: 'packages-section', [
      div(classes: 'packages-section__header', [
        span(classes: 'section-badge', [.text('// packages')]),
        h2(classes: 'section-heading', [.text('Open Source Packages')]),
        p(classes: 'packages-section__sub', [
          .text(
            'Dart and Flutter packages published on pub.dev, used by developers worldwide.',
          ),
        ]),
      ]),
      div(classes: 'packages-section__grid', [
        for (final pkg in packages) PackageCard(package: pkg),
      ]),
      div(classes: 'packages-section__footer', [
        a(
          href: 'https://pub.dev/publishers/andyhorn.dev/packages',
          classes: 'packages-section__view-all',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('View all packages →')],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.packages-section', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(100),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '48px'},
      ),
      css('.packages-section__header').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '16px'},
      ),
      css('.packages-section__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(16),
        color: textMuted,
        margin: Spacing.zero,
      ),
      css('.packages-section__grid').styles(
        raw: {
          'display': 'grid',
          'grid-template-columns': 'repeat(3, 1fr)',
          'gap': '24px',
        },
      ),
      css('.packages-section__footer').styles(
        display: .flex,
        justifyContent: .center,
      ),
      css('.packages-section__view-all').styles(
        display: .inlineBlock,
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        fontWeight: FontWeight.w500,
        color: accentPurple,
        raw: {
          'text-decoration': 'none',
          'border': '1px solid ${accentPurple.value}',
          'padding': '10px 24px',
          'border-radius': '8px',
          'transition': 'background-color 0.2s, color 0.2s',
        },
      ),
      css('.packages-section__view-all:hover').styles(
        backgroundColor: accentPurple,
        color: Color('#0A0A0A'),
      ),
    ]),
    css('@media (max-width: ${breakpointMd}px)', [
      css('.packages-section').styles(
        padding: Spacing.symmetric(vertical: 60.px, horizontal: 24.px),
      ),
      css('.packages-section__grid').styles(
        raw: {'grid-template-columns': 'repeat(2, 1fr)'},
      ),
    ]),
    css('@media (max-width: ${breakpointSm}px)', [
      css('.packages-section__grid').styles(
        raw: {'grid-template-columns': '1fr'},
      ),
    ]),
  ];
}
