import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class BridgeSection extends StatelessComponent {
  const BridgeSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'bridge', [
      div(classes: 'bridge__card', [
        // Left pane — main.dart
        div(classes: 'bridge__pane bridge__pane--left', [
          span(classes: 'bridge__file-badge', [.text('main.dart')]),
          pre(classes: 'bridge__code', [
            span(classes: 'bridge__code--muted', [.text('void main() {\n')]),
            span(classes: 'bridge__code--bright', [.text('  runApp(PortfolioApp());\n')]),
            span(classes: 'bridge__code--muted', [.text('}\n\n')]),
            span(classes: 'bridge__code--muted', [.text('class PortfolioApp extends StatelessWidget {\n')]),
            span(classes: 'bridge__code--bright', [.text("  const experience = '6+ years';\n")]),
            span(classes: 'bridge__code--bright', [.text("  const company = 'Very Good Ventures';\n")]),
            span(classes: 'bridge__code--bright', [.text('  const pubPackages = 12;\n')]),
            span(classes: 'bridge__code--bright', [.text('  const appsShipped = 2;\n')]),
            span(classes: 'bridge__code--muted', [.text('}')]),
          ]),
        ]),
        // Right pane — pubspec.yaml
        div(classes: 'bridge__pane bridge__pane--right', [
          span(classes: 'bridge__file-badge', [.text('pubspec.yaml')]),
          pre(classes: 'bridge__code', [
            span(classes: 'bridge__code--muted', [.text('name: blog\n')]),
            span(classes: 'bridge__code--muted', [.text('description: A portfolio app built with Jaspr.\n')]),
            span(classes: 'bridge__code--muted', [
              .text('repository: '),
              a(href: 'https://github.com/andyhorn/blog', classes: 'bridge__code--link', [
                .text('https://github.com/andyhorn/blog'),
              ]),
              .text('\n\n'),
            ]),
            span(classes: 'bridge__code--muted', [.text('dependencies:\n')]),
            span(classes: 'bridge__code--bright', [.text('  bloc: ^8.1.0\n')]),
            span(classes: 'bridge__code--bright', [.text('  equatable: ^2.0.0\n')]),
            span(classes: 'bridge__code--bright', [.text('  go_router: ^13.0.0\n')]),
            span(classes: 'bridge__code--bright', [.text('  simple_routes: ^2.0.0')]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.bridge', [
      css('&').styles(
        display: .flex,
        justifyContent: .center,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(80),
          horizontal: Unit.pixels(120),
        ),
        backgroundColor: bgBase,
      ),
      css('.bridge__card').styles(
        display: .flex,
        backgroundColor: bgBridge,
        radius: .all(.circular(8.px)),
        overflow: .clip,
        raw: {
          'width': '100%',
          'max-width': '1200px',
          'box-shadow': '0 8px 40px #00000040, 0 0 80px #A855F720',
        },
      ),
      css('.bridge__pane').styles(
        display: .flex,
        flexDirection: .column,
        padding: Spacing.all(Unit.pixels(32)),
        raw: {'flex': '1', 'gap': '16px'},
      ),
      css('.bridge__pane--left').styles(backgroundColor: bgPaneL),
      css('.bridge__pane--right').styles(backgroundColor: bgPaneR),
      css('.bridge__file-badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        color: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(4),
          horizontal: Unit.pixels(10),
        ),
        raw: {
          'background': '#A855F720',
          'border-radius': '4px',
          'display': 'inline-block',
        },
      ),
      css('.bridge__code').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(14),
        color: textMuted,
        margin: Spacing.zero,
        raw: {
          'line-height': '1.7',
          'white-space': 'pre',
          'overflow': 'auto',
        },
      ),
      css('.bridge__code--muted').styles(color: textMuted),
      css('.bridge__code--bright').styles(color: textPrimary),
      css('.bridge__code--link').styles(
        color: textMuted,
        textDecoration: .none,
        cursor: .pointer,
      ),
      css('.bridge__code--link:hover').styles(
        textDecoration: TextDecoration(line: .underline),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.bridge').styles(
        padding: Spacing.symmetric(vertical: 48.px, horizontal: 16.px),
      ),
      css('.bridge .bridge__card').styles(
        flexDirection: .column,
      ),
      css('.bridge .bridge__pane').styles(
        padding: Spacing.all(20.px),
      ),
      css('.bridge .bridge__code').styles(
        raw: {'font-size': '12px'},
      ),
    ]),
  ];
}
