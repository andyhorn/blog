import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({super.key});

  static const _skills = ['Flutter', 'Dart', 'pub.dev', 'Firebase'];

  @override
  Component build(BuildContext context) {
    return section(id: 'about', classes: 'about', [
      // Left column
      div(classes: 'about__left', [
        span(classes: 'section-badge', [.text('// about me')]),
        h2(classes: 'about__heading', [
          .text('Building beautiful'),
          br(),
          .text('things with Flutter'),
        ]),
        p(classes: 'about__bio', [
          .text(
            "I'm a software engineer at Very Good Ventures, specializing in Flutter and Dart. "
            'Over the past 6+ years I\'ve shipped cross-platform apps used by thousands of people '
            'and published open-source packages with hundreds of stars on pub.dev.',
          ),
        ]),
        div(classes: 'about__skills', [
          for (final skill in _skills) span(classes: 'about__skill-pill', [.text(skill)]),
        ]),
      ]),
      // Right column — experience card
      div(classes: 'about__right', [
        div(classes: 'about__exp-card', [
          span(classes: 'about__exp-date', [.text('2015 – Present')]),
          span(classes: 'about__exp-company', [.text('Very Good Ventures')]),
          span(classes: 'about__exp-title', [.text('Flutter Engineer')]),
          p(classes: 'about__exp-desc', [
            .text(
              'Building cross-platform mobile and web applications '
              'with Flutter, Dart, and a strong emphasis on clean architecture, '
              'testing, and developer experience.',
            ),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about', [
      css('&').styles(
        display: .flex,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(100),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '80px'},
      ),
      css('.about__left').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'flex': '1', 'gap': '24px'},
      ),
      css('.about__heading').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(48),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        raw: {'line-height': '1.1', 'letter-spacing': '-1.5px'},
      ),
      css('.about__bio').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(16),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(500),
        raw: {'line-height': '1.7'},
      ),
      css('.about__skills').styles(
        display: .flex,
        raw: {'gap': '8px', 'flex-wrap': 'wrap'},
      ),
      css('.about__skill-pill').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(13),
        color: textPrimary,
        backgroundColor: borderDefault,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(6),
          horizontal: Unit.pixels(14),
        ),
        raw: {
          'border': '1px solid #2A2A2A',
          'border-radius': '9999px',
          'display': 'inline-block',
        },
      ),
      css('.about__right').styles(
        raw: {'width': '480px', 'flex-shrink': '0'},
      ),
      css('.about__exp-card').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        padding: Spacing.all(Unit.pixels(24)),
        raw: {'border': '1px solid #1A1A1A', 'gap': '8px'},
      ),
      css('.about__exp-date').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: accentPurple,
      ),
      css('.about__exp-company').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.about__exp-title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(18),
        fontWeight: .w600,
        color: textPrimary,
      ),
      css('.about__exp-desc').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(400),
        raw: {'line-height': '1.6'},
      ),
    ]),
  ];
}
