import 'package:jaspr/dom.dart';

// ─── Colors ──────────────────────────────────────────────────────────────────

// Backgrounds
const bgBase = Color('#0A0A0A');
const bgCard = Color('#111111');
const bgSecondary = Color('#0D0D0D');
const bgBridge = Color('#141414');
const bgPaneL = Color('#111111');
const bgPaneR = Color('#0F0F0F');

// Borders
const borderDefault = Color('#1A1A1A');
const borderStrong = Color('#2A2A2A');

// Text
const textPrimary = Color('#FFFFFF');
const textMuted = Color('#A1A1AA');

// Accent
const accentPurple = Color('#A855F7');

// Tag colors
const tagFlutterColor = Color('#A855F7');
const tagFlutterBg = Color('#A855F720');
const tagDartColor = Color('#3B82F6');
const tagDartBg = Color('#3B82F620');
const tagArchColor = Color('#10B981');
const tagArchBg = Color('#10B98120');
const tagOpenSourceColor = Color('#F59E0B');
const tagOpenSourceBg = Color('#F59E0B20');
const tagDevXColor = Color('#10B981');
const tagDevXBg = Color('#10B98120');

// Semantic accents
const accentBlue = Color('#3B82F6');
const accentGreen = Color('#10B981');
const accentAmber = Color('#F59E0B');

// ─── Typography ──────────────────────────────────────────────────────────────

const fontSizeXs = Unit.rem(0.75); // 12px
const fontSizeSm = Unit.rem(0.875); // 14px
const fontSizeBase = Unit.rem(1); // 16px
const fontSizeLg = Unit.rem(1.125); // 18px
const fontSizeXl = Unit.rem(1.25); // 20px
const fontSize2Xl = Unit.rem(1.5); // 24px
const fontSize3Xl = Unit.rem(1.875); // 30px
const fontSize4Xl = Unit.rem(2.25); // 36px

// ─── Spacing (4px base grid) ─────────────────────────────────────────────────

const space1 = Unit.pixels(4);
const space2 = Unit.pixels(8);
const space3 = Unit.pixels(12);
const space4 = Unit.pixels(16);
const space6 = Unit.pixels(24);
const space8 = Unit.pixels(32);
const space12 = Unit.pixels(48);
const space16 = Unit.pixels(64);
const space20 = Unit.pixels(80);
const space24 = Unit.pixels(96);
const space25 = Unit.pixels(100);

// ─── Breakpoints (px integers for media queries) ─────────────────────────────

const breakpointSm = 640;
const breakpointMd = 768;
const breakpointLg = 1024;
const breakpointXl = 1280;

// ─── Global base styles ───────────────────────────────────────────────────────

@css
List<StyleRule> get globalStyles => [
  css('*, *::before, *::after').styles(
    boxSizing: BoxSizing.borderBox,
  ),
  css('html, body').styles(
    padding: Spacing.zero,
    margin: Spacing.zero,
    color: textPrimary,
    fontFamily: const FontFamily.list([FontFamily('Inter'), FontFamilies.sansSerif]),
    fontSize: fontSizeBase,
    backgroundColor: bgBase,
    raw: {
      'line-height': '1.6',
      '-webkit-font-smoothing': 'antialiased',
    },
  ),
  css('a').styles(
    color: Color.inherit,
    textDecoration: TextDecoration.none,
  ),
  css('img').styles(
    display: Display.block,
    maxWidth: 100.percent,
  ),
  css('.container').styles(
    maxWidth: 1200.px,
    padding: const Spacing.symmetric(horizontal: space8),
    margin: const Spacing.symmetric(horizontal: Unit.auto),
  ),
];
