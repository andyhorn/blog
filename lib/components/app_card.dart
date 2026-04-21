import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/app.dart';

class AppCard extends StatelessComponent {
  const AppCard({required this.app, super.key});

  final App app;

  @override
  Component build(BuildContext context) {
    return a(
      href: app.storeUrl,
      classes: 'app-card',
      attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
      [
        // Colored placeholder — replace with img(src: app.imageUrl) when screenshots exist
        div(
          classes: 'app-card__image',
          styles: Styles(backgroundColor: Color('${app.badgeColor}20')),
          [],
        ),
        div(classes: 'app-card__body', [
          span(
            classes: 'app-card__badge',
            styles: Styles(
              backgroundColor: Color('${app.badgeColor}20'),
              color: Color(app.badgeColor),
            ),
            [.text('App Store')],
          ),
          h3(classes: 'app-card__title', [.text(app.title)]),
          p(classes: 'app-card__desc', [.text(app.description)]),
          // Tags
          if (app.tags.isNotEmpty)
            div(classes: 'app-card__tags', [
              for (final tag in app.tags) span(classes: 'app-card__tag', [.text(tag)]),
            ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.app-card', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        overflow: .clip,
        color: textPrimary,
        raw: {'border': '1px solid #1A1A1A', 'text-decoration': 'none'},
      ),
      css('.app-card__image').styles(
        raw: {'height': '200px', 'flex-shrink': '0'},
      ),
      css('.app-card__body').styles(
        display: .flex,
        flexDirection: .column,
        padding: Spacing.all(Unit.pixels(24)),
        raw: {'gap': '8px'},
      ),
      css('.app-card__badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(10),
        fontWeight: .w600,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(4),
          horizontal: Unit.pixels(10),
        ),
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'border-radius': '12px',
        },
      ),
      css('.app-card__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(22),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
      ),
      css('.app-card__desc').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(14),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(260),
        raw: {'line-height': '1.6'},
      ),
      css('.app-card__tags').styles(
        display: .flex,
        raw: {'gap': '6px', 'flex-wrap': 'wrap', 'margin-top': '4px'},
      ),
      css('.app-card__tag').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(11),
        color: textMuted,
        backgroundColor: borderDefault,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(2),
          horizontal: Unit.pixels(8),
        ),
        raw: {'border-radius': '4px'},
      ),
    ]),
  ];
}
