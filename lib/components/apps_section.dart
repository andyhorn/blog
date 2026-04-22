import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/apps.dart';
import 'app_card.dart';

class AppsSection extends StatelessComponent {
  const AppsSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(id: 'apps', classes: 'apps-section', [
      div(classes: 'apps-section__header', [
        span(classes: 'section-badge', [.text('// apps')]),
        h2(classes: 'section-heading', [.text('Published Apps')]),
        p(classes: 'apps-section__sub', [
          .text('Cross-platform iOS apps built with Flutter, available on the App Store.'),
        ]),
      ]),
      div(classes: 'apps-section__grid', [
        for (final app in apps) AppCard(app: app),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.apps-section', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(100),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '48px'},
      ),
      css('.apps-section__header').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '16px'},
      ),
      css('.apps-section__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(16),
        color: textMuted,
        margin: Spacing.zero,
      ),
      css('.apps-section__grid').styles(
        raw: {
          'display': 'grid',
          'grid-template-columns': 'repeat(4, 1fr)',
          'gap': '24px',
        },
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.apps-section').styles(
        padding: Spacing.symmetric(vertical: 60.px, horizontal: 24.px),
      ),
      css('.apps-section .apps-section__grid').styles(
        raw: {'grid-template-columns': 'repeat(2, 1fr)'},
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointSm.px), [
      css('.apps-section .apps-section__grid').styles(
        raw: {'grid-template-columns': '1fr'},
      ),
    ]),
  ];
}
