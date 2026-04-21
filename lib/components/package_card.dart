import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/package.dart';

class PackageCard extends StatelessComponent {
  const PackageCard({required this.package, super.key});

  final Package package;

  @override
  Component build(BuildContext context) {
    return div(classes: 'package-card', [
      // Top row: icon + stars
      div(classes: 'package-card__top', [
        div(
          classes: 'package-card__icon',
          styles: Styles(backgroundColor: Color('${package.iconColor}20')),
          [
            span(styles: Styles(color: Color(package.iconColor)), [.text('●')]),
          ],
        ),
        span(classes: 'package-card__stars', [.text('⭐ ${package.stars}')]),
      ]),
      // Name
      span(classes: 'package-card__name', [.text(package.name)]),
      // Description
      p(classes: 'package-card__desc', [.text(package.description)]),
      // Footer: version · pub.dev link
      div(classes: 'package-card__footer', [
        span(
          classes: 'package-card__version',
          styles: Styles(color: Color(package.iconColor)),
          [.text(package.version)],
        ),
        .text(' · '),
        a(
          href: package.pubDevUrl,
          classes: 'package-card__pubdev',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('pub.dev')],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.package-card', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        padding: Spacing.all(Unit.pixels(24)),
        raw: {'border': '1px solid #1A1A1A', 'gap': '16px'},
      ),
      css('.package-card__top').styles(
        display: .flex,
        justifyContent: .spaceBetween,
        alignItems: .center,
      ),
      css('.package-card__icon').styles(
        radius: .all(.circular(8.px)),
        raw: {
          'width': '40px',
          'height': '40px',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'font-size': '18px',
          'flex-shrink': '0',
        },
      ),
      css('.package-card__stars').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.package-card__name').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(15),
        fontWeight: .w600,
        color: textPrimary,
      ),
      css('.package-card__desc').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(13),
        color: textMuted,
        margin: Spacing.zero,
        raw: {'line-height': '1.6'},
      ),
      css('.package-card__footer').styles(
        display: .flex,
        alignItems: .center,
        raw: {'gap': '4px'},
      ),
      css('.package-card__version').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
      ),
      css('.package-card__pubdev').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(11),
        color: textMuted,
        raw: {'text-decoration': 'none'},
      ),
      css('.package-card__pubdev:hover').styles(color: textPrimary),
    ]),
  ];
}
