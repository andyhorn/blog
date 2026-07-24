import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/package.dart';
import '../services/pubdev_fetch_stub.dart' if (dart.library.js_interop) '../services/pubdev_fetch_web.dart';

@client
class PackageCard extends StatefulComponent {
  const PackageCard({
    required this.name,
    required this.description,
    required this.initialVersion,
    required this.initialStars,
    required this.pubDevUrl,
    required this.iconColor,
    this.featured = false,
    super.key,
  });

  factory PackageCard.fromPackage(Package pkg) => PackageCard(
    name: pkg.name,
    description: pkg.description,
    initialVersion: pkg.version,
    initialStars: pkg.stars,
    pubDevUrl: pkg.pubDevUrl,
    iconColor: pkg.iconColor,
  );

  factory PackageCard.featuredFromPackage(Package pkg) => PackageCard(
    name: pkg.name,
    description: pkg.description,
    initialVersion: pkg.version,
    initialStars: pkg.stars,
    pubDevUrl: pkg.pubDevUrl,
    iconColor: pkg.iconColor,
    featured: true,
  );

  final String name;
  final String description;
  final String initialVersion;
  final int initialStars;
  final String pubDevUrl;
  final String iconColor;
  final bool featured;

  @override
  State<PackageCard> createState() => _PackageCardState();

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
      // Featured variant
      css('.package-card--featured').styles(
        padding: Spacing.all(Unit.pixels(28)),
        raw: {'gap': '20px', 'height': '100%'},
      ),
      css('.package-card__top-meta').styles(
        display: .flex,
        alignItems: .center,
        raw: {'gap': '12px'},
      ),
      css('.package-card__badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        color: accentGreen,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(5),
          horizontal: Unit.pixels(12),
        ),
        raw: {'background': '#10B98115', 'border-radius': '9999px'},
      ),
      css('.package-card__name--lg').styles(fontSize: Unit.pixels(22)),
      css('.package-card__spacer').styles(raw: {'flex': '1'}),
      css('.package-card__stats').styles(
        display: .flex,
        raw: {'gap': '24px'},
      ),
      css('.package-card__stat').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '2px'},
      ),
      css('.package-card__stat-value').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(18),
        fontWeight: .w700,
        color: textPrimary,
      ),
      css('.package-card__stat-label').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(10),
        color: Color('#71717A'),
        raw: {'letter-spacing': '0.5px'},
      ),
      css('.package-card__install').styles(
        display: .flex,
        alignItems: .center,
        backgroundColor: bgBase,
        radius: .all(.circular(6.px)),
        padding: Spacing.symmetric(
          vertical: Unit.pixels(10),
          horizontal: Unit.pixels(14),
        ),
        raw: {'gap': '8px', 'border': '1px solid #1A1A1A'},
      ),
      css('.package-card__install-prompt').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(13),
        color: accentGreen,
      ),
      css('.package-card__install-cmd').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(13),
        color: Color('#E4E4E7'),
      ),
    ]),
  ];
}

class _PackageCardState extends State<PackageCard> {
  late String _version = component.initialVersion;
  late int _likes = component.initialStars;
  int? _pubPoints;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      unawaited(_fetchPubDev());
    }
  }

  Future<void> _fetchPubDev() async {
    try {
      final results = await Future.wait([
        fetchJson('https://pub.dev/api/packages/${component.name}'),
        fetchJson('https://pub.dev/api/packages/${component.name}/score'),
      ]);
      final latest = (results[0]['latest'] as Map?)?['version'] as String?;
      final likes = (results[1]['likeCount'] as num?)?.toInt();
      final points = (results[1]['grantedPoints'] as num?)?.toInt();
      if (!mounted) return;
      setState(() {
        if (latest != null) _version = 'v$latest';
        if (likes != null) _likes = likes;
        if (points != null) _pubPoints = points;
      });
    } catch (_) {
      // Keep fallback values if the request fails.
    }
  }

  Component _stat(String value, String label) => div(classes: 'package-card__stat', [
    span(classes: 'package-card__stat-value', [.text(value)]),
    span(classes: 'package-card__stat-label', [.text(label)]),
  ]);

  Component _buildFeatured() {
    return div(classes: 'package-card package-card--featured', [
      div(classes: 'package-card__top', [
        div(
          classes: 'package-card__icon',
          styles: Styles(backgroundColor: Color('${component.iconColor}20')),
          [
            span(styles: Styles(color: Color(component.iconColor)), [.text('●')]),
          ],
        ),
        div(classes: 'package-card__top-meta', [
          span(classes: 'package-card__stars', [.text('⭐ $_likes')]),
          span(classes: 'package-card__badge', [.text('Most popular')]),
        ]),
      ]),
      span(classes: 'package-card__name package-card__name--lg', [.text(component.name)]),
      p(classes: 'package-card__desc', [.text(component.description)]),
      div(classes: 'package-card__spacer', []),
      if (_pubPoints != null)
        div(classes: 'package-card__stats', [
          _stat('$_pubPoints', 'PUB POINTS'),
        ]),
      div(classes: 'package-card__install', [
        span(classes: 'package-card__install-prompt', [.text(r'$')]),
        span(classes: 'package-card__install-cmd', [
          .text('flutter pub add ${component.name}'),
        ]),
      ]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    if (component.featured) return _buildFeatured();
    return div(classes: 'package-card', [
      div(classes: 'package-card__top', [
        div(
          classes: 'package-card__icon',
          styles: Styles(backgroundColor: Color('${component.iconColor}20')),
          [
            span(styles: Styles(color: Color(component.iconColor)), [
              .text('●'),
            ]),
          ],
        ),
        span(classes: 'package-card__stars', [.text('⭐ $_likes')]),
      ]),
      span(classes: 'package-card__name', [.text(component.name)]),
      p(classes: 'package-card__desc', [.text(component.description)]),
      div(classes: 'package-card__footer', [
        span(
          classes: 'package-card__version',
          styles: Styles(color: Color(component.iconColor)),
          [.text(_version)],
        ),
        .text(' · '),
        a(
          href: component.pubDevUrl,
          classes: 'package-card__pubdev',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('pub.dev')],
        ),
      ]),
    ]);
  }
}
