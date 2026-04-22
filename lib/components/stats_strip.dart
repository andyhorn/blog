import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class StatsStrip extends StatelessComponent {
  const StatsStrip({super.key});

  static const _stats = [
    ('6+', 'Years Experience'),
    ('12', 'pub.dev Packages'),
    ('2', 'Published Apps'),
    ('∞', 'Cups of Coffee'),
  ];

  @override
  Component build(BuildContext context) {
    return section(classes: 'stats-strip', [
      for (var i = 0; i < _stats.length; i++) ...[
        if (i > 0) div(classes: 'stats-strip__divider', []),
        div(classes: 'stats-strip__stat', [
          span(classes: 'stats-strip__value', [.text(_stats[i].$1)]),
          span(classes: 'stats-strip__label', [.text(_stats[i].$2)]),
        ]),
      ],
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.stats-strip', [
      css('&').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .spaceBetween,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(horizontal: Unit.pixels(120)),
        raw: {
          'height': '100px',
          'border-top': '1px solid #1A1A1A',
          'border-bottom': '1px solid #1A1A1A',
        },
      ),
      css('.stats-strip__stat').styles(
        display: .flex,
        flexDirection: .column,
        alignItems: .center,
        raw: {'gap': '4px'},
      ),
      css('.stats-strip__value').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(32),
        fontWeight: .w700,
        color: accentPurple,
      ),
      css('.stats-strip__label').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(13),
        color: textMuted,
      ),
      css('.stats-strip__divider').styles(
        width: Unit.pixels(1),
        backgroundColor: borderDefault,
        raw: {'height': '40px', 'flex-shrink': '0'},
      ),
    ]),
  ];
}
