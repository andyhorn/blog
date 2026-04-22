import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      span(classes: 'site-footer__left', [.text('andyhorn.dev')]),
      span(classes: 'site-footer__right', [.text('Built with Jaspr')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: space8, horizontal: Unit.pixels(120)),
        border: .only(
          top: .solid(color: borderDefault, width: 1.px),
        ),
        justifyContent: .spaceBetween,
        alignItems: .center,
        backgroundColor: bgBase,
      ),
      css('.site-footer__left').styles(
        color: textMuted,
        fontFamily: .list([FontFamily('Geist Mono'), FontFamilies.monospace]),
        fontSize: Unit.pixels(13),
      ),
      css('.site-footer__right').styles(
        color: textMuted,
        fontFamily: .list([FontFamily('Inter'), FontFamilies.sansSerif]),
        fontSize: Unit.pixels(13),
      ),
    ]),
    css('@media (max-width: ${breakpointMd}px)', [
      css('.site-footer').styles(
        padding: Spacing.symmetric(horizontal: space6, vertical: space8),
      ),
    ]),
  ];
}
