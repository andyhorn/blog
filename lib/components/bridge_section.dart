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
            .text(
              "import 'package:flutter/material.dart';\n"
              "import 'package:flutter_bloc/flutter_bloc.dart';\n"
              '\n'
              'void main() {\n'
              '  runApp(\n'
              '    BlocProvider(\n'
              '      create: (_) => AppCubit(),\n'
              '      child: const App(),\n'
              '    ),\n'
              '  );\n'
              '}',
            ),
          ]),
        ]),
        // Right pane — pubspec.yaml
        div(classes: 'bridge__pane bridge__pane--right', [
          span(classes: 'bridge__file-badge', [.text('pubspec.yaml')]),
          pre(classes: 'bridge__code', [
            .text(
              'name: my_app\n'
              'description: A beautiful Flutter app.\n'
              '\n'
              'dependencies:\n'
              '  flutter:\n'
              '    sdk: flutter\n'
              '  flutter_animated_list: ^2.1.0\n'
              '  dart_result: ^1.4.2\n'
              '  bloc_navigator: ^3.0.1',
            ),
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
    ]),
  ];
}
