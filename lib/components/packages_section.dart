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
    ]),
  ];
}
