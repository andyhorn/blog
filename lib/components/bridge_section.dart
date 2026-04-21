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
            span(classes: 'bridge__code--bright', [.text("  final experience = '5+ years';\n")]),
            span(classes: 'bridge__code--bright', [.text("  final platform = 'Flutter & Dart';\n")]),
            span(classes: 'bridge__code--bright', [.text('  final pubPackages = 20;\n')]),
            span(classes: 'bridge__code--bright', [.text('  final appsShipped = 4;\n')]),
            span(classes: 'bridge__code--muted', [.text('}')]),
          ]),
        ]),
        // Right pane — pubspec.yaml
        div(classes: 'bridge__pane bridge__pane--right', [
          span(classes: 'bridge__file-badge', [.text('pubspec.yaml')]),
          pre(classes: 'bridge__code', [
            span(classes: 'bridge__code--muted', [.text('name: andrew_portfolio\n')]),
            span(classes: 'bridge__code--bright', [.text("sdk: '>=3.0.0 <4.0.0'\n")]),
            span(classes: 'bridge__code--muted', [.text('\ndependencies:\n')]),
            span(classes: 'bridge__code--bright', [.text('  flutter: sdk: flutter\n')]),
            span(classes: 'bridge__code--bright', [.text('  bloc: ^8.1.0\n')]),
            span(classes: 'bridge__code--bright', [.text('  go_router: ^13.0.0')]),
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
    ]),
  ];
}
