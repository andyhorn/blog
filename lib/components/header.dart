import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    final activePath = context.url;

    return header(classes: 'site-header', [
      // Logo
      a(href: '/', classes: 'site-header__logo', [.text('andyhorn.dev')]),
      // Nav links
      nav(classes: 'site-header__nav', [
        a(href: '/#about', classes: 'site-header__link', [.text('About')]),
        a(href: '/#apps', classes: 'site-header__link', [.text('Apps')]),
        a(href: '/#packages', classes: 'site-header__link', [.text('Packages')]),
        div(
          classes: activePath.startsWith('/blog')
              ? 'site-header__nav-item site-header__nav-item--active'
              : 'site-header__nav-item',
          [
            Link(
              to: '/blog',
              child: span(classes: 'site-header__link', [.text('Blog')]),
            ),
          ],
        ),
      ]),
      // CTA
      a(href: '/#contact', classes: 'site-header__cta', [.text('Get in touch')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header', [
      css('&').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .spaceBetween,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(horizontal: Unit.pixels(120)),
        raw: {
          'height': '72px',
          'border-bottom': '1px solid #1A1A1A',
          'position': 'sticky',
          'top': '0',
          'z-index': '100',
        },
      ),
      css('.site-header__logo').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(20),
        fontWeight: .w700,
        color: textPrimary,
        raw: {'text-decoration': 'none', 'letter-spacing': '-0.5px'},
      ),
      css('.site-header__nav').styles(
        display: .flex,
        alignItems: .center,
        raw: {'gap': '40px'},
      ),
      css('.site-header__link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        color: textMuted,
        raw: {'text-decoration': 'none'},
      ),
      css('.site-header__link:hover').styles(color: textPrimary),
      css('.site-header__nav-item--active .site-header__link').styles(
        color: accentPurple,
        fontWeight: .w600,
      ),
      css('.site-header__cta').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        fontWeight: .w600,
        color: bgBase,
        backgroundColor: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(9),
          horizontal: Unit.pixels(20),
        ),
        raw: {
          'border-radius': '9999px',
          'text-decoration': 'none',
          'display': 'inline-flex',
          'align-items': 'center',
        },
      ),
    ]),
  ];
}
