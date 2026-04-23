import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

@client
class CopyButton extends StatefulComponent {
  const CopyButton({required this.codeBlockId, super.key});

  final String codeBlockId;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  void _copy() {
    if (kIsWeb) {
      final wrapper = web.document.getElementById(component.codeBlockId);
      final codeEl = wrapper?.querySelector('code');
      final text = codeEl?.textContent ?? '';
      web.window.navigator.clipboard.writeText(text);
    }
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () => setState(() => _copied = false));
  }

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'copy-btn',
      onClick: _copy,
      [.text(_copied ? 'Copied!' : 'Copy')],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.copy-btn').styles(
      fontFamily: fontGeistMono,
      fontSize: Unit.pixels(11),
      fontWeight: .w600,
      color: textMuted,
      raw: {
        'position': 'absolute',
        'top': '8px',
        'right': '8px',
        'background': 'rgba(255,255,255,0.06)',
        'border': '1px solid #2A2A2A',
        'border-radius': '4px',
        'padding': '3px 10px',
        'cursor': 'pointer',
        'transition': 'color 0.15s, background 0.15s, border-color 0.15s',
        'line-height': '1.4',
        'z-index': '1',
      },
    ),
    css('.copy-btn:hover').styles(
      color: accentPurple,
      raw: {
        'background': 'rgba(168,85,247,0.1)',
        'border-color': 'rgba(168,85,247,0.3)',
      },
    ),
  ];
}
