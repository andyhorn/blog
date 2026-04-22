import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:universal_web/web.dart' as web;
import '../constants/theme.dart';

@client
class Header extends StatefulComponent {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();

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
      // Hamburger — hidden on desktop, shown on mobile
      css('.site-header__hamburger').styles(
        display: .none,
        alignItems: .center,
        justifyContent: .center,
        backgroundColor: Colors.transparent,
        color: textPrimary,
        raw: {
          'border': 'none',
          'cursor': 'pointer',
          'font-size': '22px',
          'width': '40px',
          'height': '40px',
          'border-radius': '8px',
        },
      ),
      // Mobile nav dropdown — full-width below header row
      css('.site-header__mobile-nav').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgBase,
        raw: {
          'width': '100%',
          'padding': '16px',
          'gap': '8px',
          'border-top': '1px solid #1A1A1A',
        },
      ),
      css('.site-header__mobile-link').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(16),
        color: textMuted,
        padding: Spacing.symmetric(vertical: 12.px, horizontal: 8.px),
        raw: {'text-decoration': 'none', 'display': 'block'},
      ),
      css('.site-header__mobile-link--cta').styles(
        color: accentPurple,
        fontWeight: .w600,
      ),
      css('.site-header__mobile-link:hover').styles(color: textPrimary),
    ]),
    // Mobile breakpoint
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.site-header').styles(
        padding: Spacing.symmetric(vertical: 16.px, horizontal: 16.px),
        raw: {'flex-wrap': 'wrap', 'height': 'auto', 'min-height': '72px'},
      ),
      css('.site-header .site-header__nav').styles(display: .none),
      css('.site-header .site-header__cta').styles(display: .none),
      css('.site-header .site-header__hamburger').styles(display: .flex),
    ]),
  ];
}

class _HeaderState extends State<Header> {
  bool _menuOpen = false;

  void _navigateTo(String href) {
    setState(() => _menuOpen = false);
    if (kIsWeb) {
      web.window.location.href = href;
    }
  }

  @override
  Component build(BuildContext context) {
    final activePath = context.url;

    return header(classes: 'site-header', [
      // Logo
      a(href: '/', classes: 'site-header__logo', [.text('andyhorn.dev')]),
      // Desktop nav links
      nav(classes: 'site-header__nav', [
        a(href: '/#about', classes: 'site-header__link', [.text('About')]),
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
      // Desktop CTA
      a(href: '/#contact', classes: 'site-header__cta', [.text('Get in touch')]),
      // Hamburger — visible on mobile only via CSS
      button(
        classes: 'site-header__hamburger',
        onClick: () => setState(() => _menuOpen = !_menuOpen),
        attributes: {'aria-label': _menuOpen ? 'Close menu' : 'Open menu'},
        [.text(_menuOpen ? '✕' : '☰')],
      ),
      // Mobile dropdown — rendered only when open
      if (_menuOpen)
        nav(classes: 'site-header__mobile-nav', [
          a(
            href: '/#about',
            classes: 'site-header__mobile-link',
            onClick: () => _navigateTo('/#about'),
            [.text('About')],
          ),
          a(
            href: '/#packages',
            classes: 'site-header__mobile-link',
            onClick: () => _navigateTo('/#packages'),
            [.text('Packages')],
          ),
          Link(
            to: '/blog',
            child: span(classes: 'site-header__mobile-link', [.text('Blog')]),
          ),
          a(
            href: '/#contact',
            classes: 'site-header__mobile-link site-header__mobile-link--cta',
            onClick: () => _navigateTo('/#contact'),
            [.text('Get in touch')],
          ),
        ]),
    ]);
  }
}
