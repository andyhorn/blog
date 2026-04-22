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
            "I'm a Flutter engineer at Very Good Ventures and founder of Ember City Studio. "
            "I've spent 6+ years shipping production apps across finance, health, and consumer SaaS "
            '— and building open-source tools for the Flutter ecosystem.',
          ),
        ]),
        div(classes: 'about__skills', [
          for (final skill in _skills) span(classes: 'about__skill-pill', [.text(skill)]),
        ]),
      ]),
      // Right column — experience timeline
      div(classes: 'about__right', [
        div(classes: 'about__timeline', [
          div(classes: 'about__timeline-line', []),
          div(classes: 'about__timeline-entry', [
            span(classes: 'about__timeline-dot', []),
            div(classes: 'about__timeline-content', [
              span(classes: 'about__timeline-title', [.text('Software Engineer 3')]),
              span(classes: 'about__timeline-meta', [.text('Very Good Ventures  ·  Sep 2025 – Present')]),
            ]),
          ]),
          div(classes: 'about__timeline-entry', [
            span(classes: 'about__timeline-dot', []),
            div(classes: 'about__timeline-content', [
              span(classes: 'about__timeline-title', [.text('Founder & Principal Engineer')]),
              span(classes: 'about__timeline-meta', [.text('Ember City Studio  ·  Feb 2025 – Present')]),
            ]),
          ]),
          div(classes: 'about__timeline-entry', [
            span(classes: 'about__timeline-dot', []),
            div(classes: 'about__timeline-content', [
              span(classes: 'about__timeline-title', [.text('Senior Flutter Engineer')]),
              span(classes: 'about__timeline-meta', [.text('MacroFactor  ·  Dec 2024 – Jul 2025')]),
            ]),
          ]),
          div(classes: 'about__timeline-entry', [
            span(classes: 'about__timeline-dot', []),
            div(classes: 'about__timeline-content', [
              span(classes: 'about__timeline-title', [.text('Software Engineer')]),
              span(classes: 'about__timeline-meta', [.text('Uptech Studio  ·  Jul 2022 – Apr 2024')]),
            ]),
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
      css('.about__timeline').styles(
        raw: {'position': 'relative'},
      ),
      css('.about__timeline-line').styles(
        raw: {
          'position': 'absolute',
          'left': '4px',
          'top': '9px',
          'bottom': '9px',
          'width': '2px',
          'background': '#A855F730',
        },
      ),
      css('.about__timeline-entry').styles(
        display: .flex,
        raw: {
          'align-items': 'flex-start',
          'gap': '12px',
          'min-height': '64px',
        },
      ),
      css('.about__timeline-dot').styles(
        raw: {
          'width': '10px',
          'height': '10px',
          'border-radius': '50%',
          'background': '#A855F7FF',
          'flex-shrink': '0',
          'margin-top': '7px',
        },
      ),
      css('.about__timeline-content').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '4px'},
      ),
      css('.about__timeline-title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(15),
        fontWeight: .w600,
        color: textPrimary,
      ),
      css('.about__timeline-meta').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        color: textMuted,
      ),
    ]),
    css('@media (max-width: ${breakpointMd}px)', [
      css('.about').styles(
        flexDirection: .column,
        padding: Spacing.symmetric(vertical: 60.px, horizontal: 24.px),
        raw: {'gap': '40px'},
      ),
      css('.about__right').styles(
        raw: {'width': '100%'},
      ),
      css('.about__heading').styles(
        raw: {'font-size': '36px'},
      ),
    ]),
  ];
}
