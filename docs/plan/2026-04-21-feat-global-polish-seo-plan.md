# feat: global polish, SEO, and responsive CSS

**Type:** Enhancement  
**Date:** 2026-04-21  
**Status:** Complete  
**Completed:** 2026-04-21  
**Complexity:** Standard  
**Phase:** 1 of 3  
**Parent plan:** `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md` (original Phase 5)  
**Depends on:** data layer & routing (complete)  
**Independent of:** `feat-portfolio-homepage-plan.md`, `feat-blog-pages-content-plan.md`

> **Note:** This plan supersedes the original Phase 5 plan after `design.pen` review. The site uses a dark purple design system (not light blue). The old `primaryColor = #01589B` and Roboto font are replaced entirely.

> **Build order**: Build Phase 1 before Phases 2 and 3. The color tokens and font imports defined here are consumed by all section components.

---

## Summary

Replace the placeholder design tokens in `lib/constants/theme.dart` with a full dark-theme design system matching `design.pen`. Import Geist, Inter, and Geist Mono fonts in `lib/main.server.dart`. Add global SEO defaults (title, meta description, OG tags, JSON-LD Person schema), update `web/manifest.json` to reflect real site metadata, and create a branded `web/404.html`.

---

## Background

The site currently has:
- `lib/constants/theme.dart` — only `primaryColor = Color('#01589B')` and basic `html, body` + `h1` rules with Roboto
- `lib/main.server.dart` — `title: 'blog'`, no global meta tags, no JSON-LD, Roboto font import
- `web/manifest.json` — `name: "blog"`, `short_name: "blog"`, `theme_color: "#0175C2"` (Flutter default)
- No `web/404.html`

The design (`design.pen`) specifies:
- Background: `#0A0A0A`, card surfaces: `#111111`, secondary bg: `#0D0D0D`
- Primary accent: `#A855F7` (purple)
- Muted text: `#A1A1AA`
- Borders: `#1A1A1A` (default), `#2A2A2A` (hover/focus)
- Fonts: Geist (headings/logo), Geist Mono (code/badges/version), Inter (body/nav/descriptions)

---

## Implementation Tasks

### `lib/constants/theme.dart` — full design system

Replace the existing file entirely:

- [ ] Remove old `primaryColor` and Roboto rules
- [ ] Add color constants:
  ```dart
  // Backgrounds
  const bgBase     = Color('#0A0A0A');  // page bg
  const bgCard     = Color('#111111');  // card bg
  const bgSecondary = Color('#0D0D0D'); // section alternates
  const bgBridge   = Color('#141414');  // bridge container
  const bgPaneL    = Color('#111111');  // bridge left pane
  const bgPaneR    = Color('#0F0F0F');  // bridge right pane

  // Borders
  const borderDefault = Color('#1A1A1A');
  const borderStrong  = Color('#2A2A2A');

  // Text
  const textPrimary = Color('#FFFFFF');
  const textMuted   = Color('#A1A1AA');

  // Accent
  const accentPurple = Color('#A855F7');

  // Tag colors
  const tagFlutterColor   = Color('#A855F7');
  const tagFlutterBg      = Color('#A855F720');
  const tagDartColor      = Color('#3B82F6');
  const tagDartBg         = Color('#3B82F620');
  const tagArchColor      = Color('#10B981');
  const tagArchBg         = Color('#10B98120');
  const tagOpenSourceColor = Color('#F59E0B');
  const tagOpenSourceBg   = Color('#F59E0B20');
  const tagDevXColor      = Color('#10B981');  // same as Architecture
  const tagDevXBg         = Color('#10B98120');

  // Semantic accents
  const accentBlue   = Color('#3B82F6');
  const accentGreen  = Color('#10B981');
  const accentAmber  = Color('#F59E0B');
  ```

- [ ] Add typography scale constants (rem units):
  ```dart
  const fontSizeXs   = 0.75.rem;   // 12px
  const fontSizeSm   = 0.875.rem;  // 14px
  const fontSizeBase = 1.rem;      // 16px
  const fontSizeLg   = 1.125.rem;  // 18px
  const fontSizeXl   = 1.25.rem;   // 20px
  const fontSize2Xl  = 1.5.rem;    // 24px
  const fontSize3Xl  = 1.875.rem;  // 30px
  const fontSize4Xl  = 2.25.rem;   // 36px
  ```

- [ ] Add spacing scale constants (4px base grid):
  ```dart
  const space1  = 4.px;
  const space2  = 8.px;
  const space3  = 12.px;
  const space4  = 16.px;
  const space6  = 24.px;
  const space8  = 32.px;
  const space12 = 48.px;
  const space16 = 64.px;
  const space20 = 80.px;
  const space24 = 96.px;
  const space25 = 100.px;
  ```

- [ ] Add responsive breakpoint constants (px integers for use in `@media` queries):
  ```dart
  const breakpointSm = 640;
  const breakpointMd = 768;
  const breakpointLg = 1024;
  const breakpointXl = 1280;
  ```

- [ ] Add global base CSS rules replacing old `html, body` + `h1` rules:
  ```dart
  @css
  static List<StyleRule> get globalStyles => [
    css('*, *::before, *::after').styles(boxSizing: BoxSizing.borderBox),
    css('html, body').styles(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      backgroundColor: bgBase,
      color: textPrimary,
      fontFamily: 'Inter, sans-serif',
      fontSize: fontSizeBase,
      lineHeight: 1.6,
      WebkitFontSmoothing: 'antialiased',
    ),
    css('a').styles(color: .inherit, textDecoration: TextDecoration(line: .none)),
    css('img').styles(display: .block, maxWidth: 100.percent),
    css('.container').styles(
      maxWidth: 1200.px,
      margin: .symmetric(horizontal: .auto()),
      padding: .symmetric(horizontal: space8),
    ),
  ];
  ```

### `lib/main.server.dart` — SEO defaults and fonts

- [ ] Change `title: 'blog'` → `title: 'Andy Horn'`
- [ ] Import Geist, Geist Mono, and Inter from Google Fonts (or CDN) in `Document(head: [...])`:
  ```dart
  // Geist (includes Geist Mono) — served via Vercel CDN
  link(
    attributes: {
      'rel': 'preconnect',
      'href': 'https://fonts.googleapis.com',
    },
  ),
  link(
    attributes: {
      'rel': 'stylesheet',
      'href': 'https://fonts.googleapis.com/css2?family=Geist:wght@400;600;700&family=Geist+Mono:wght@400;600;700&family=Inter:wght@400;600;700&display=swap',
    },
  ),
  ```
  > **Note**: Geist may not be available via Google Fonts — verify availability at build time. Fallback: self-host using `@font-face` in a `web/fonts/` folder, or use [Fontsource](https://fontsource.org/) (NPM-free CDN).
- [ ] Add global `meta` defaults:
  ```dart
  meta: {
    'description': 'Personal portfolio and blog of Andy Horn, Flutter engineer and pub.dev package author.',
    'og:image': 'https://andyhorn.dev/images/og-image.png',
    'twitter:site': '@andyjhorn',
    'twitter:card': 'summary_large_image',
  },
  ```
- [ ] Remove the existing Roboto `@import` rule from `css('html, body', [...])` (move all base CSS to `theme.dart`)
- [ ] Add JSON-LD `Person` schema:
  ```dart
  script(
    attributes: {'type': 'application/ld+json'},
    [RawText(jsonEncode({
      '@context': 'https://schema.org',
      '@type': 'Person',
      'name': 'Andy Horn',
      'url': 'https://andyhorn.dev',
      'sameAs': [
        'https://github.com/andyhorn',
        'https://linkedin.com/in/andyjhorn',
        'https://pub.dev/publishers/andyhorn.dev',
      ],
    }))],
  ),
  ```

### `web/404.html` — branded 404 page

- [ ] Create `web/404.html` matching the dark theme:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>404 — Page Not Found | Andy Horn</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    *, *::before, *::after { box-sizing: border-box; }
    body {
      margin: 0;
      padding: 0;
      background: #0A0A0A;
      color: #FFFFFF;
      font-family: Inter, system-ui, sans-serif;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      gap: 24px;
      text-align: center;
    }
    .badge {
      background: rgba(168,85,247,0.15);
      color: #A855F7;
      font-family: 'Courier New', monospace;
      font-size: 12px;
      padding: 4px 12px;
      border-radius: 4px;
    }
    h1 { font-size: 48px; font-weight: 700; margin: 0; letter-spacing: -1.5px; }
    p { color: #A1A1AA; font-size: 16px; margin: 0; }
    a {
      background: #A855F7;
      color: #0A0A0A;
      font-weight: 600;
      font-size: 15px;
      padding: 14px 28px;
      border-radius: 9999px;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <span class="badge">// 404</span>
  <h1>Page Not Found</h1>
  <p>The page you're looking for doesn't exist.</p>
  <a href="/">← Back to Home</a>
</body>
</html>
```

### `lib/components/site_footer.dart` — shared site footer

- [ ] Create as a `StatelessComponent` used by all pages (homepage, blog list, blog post)
- [ ] Dark theme: `bg #0A0A0A`, `border-top #1A1A1A`, `py 32`, `px 120`
- [ ] Layout: flex row, space-between, items center
  - Left: "andyhorn.dev" in Geist Mono 13, muted
  - Right: "Built with Flutter & Jaspr" in Inter 13, muted

### `lib/utils/tag_colors.dart` — shared tag color helpers

- [ ] Create `tagColor(String tag)` → returns foreground `Color` for a tag name
- [ ] Create `tagBgColor(String tag)` → returns background `Color` for a tag name
- [ ] Use the tag color constants from `theme.dart`; default to `textMuted` / `borderDefault` for unknown tags:
  ```dart
  Color tagColor(String tag) => switch (tag.toLowerCase()) {
    'flutter'     => tagFlutterColor,
    'dart'        => tagDartColor,
    'architecture' => tagArchColor,
    'open source' => tagOpenSourceColor,
    'devx'        => tagDevXColor,
    _             => textMuted,
  };
  Color tagBgColor(String tag) => switch (tag.toLowerCase()) {
    'flutter'     => tagFlutterBg,
    'dart'        => tagDartBg,
    'architecture' => tagArchBg,
    'open source' => tagOpenSourceBg,
    'devx'        => tagDevXBg,
    _             => borderDefault,
  };
  ```

### `web/manifest.json` — update site metadata

Current values to replace:

| Field | Current | Target |
|---|---|---|
| `name` | `"blog"` | `"Andy Horn"` |
| `short_name` | `"blog"` | `"AH"` |
| `description` | `"A new Jaspr project"` | `"Flutter engineer & pub.dev package author."` |
| `theme_color` | `"#0175C2"` | `"#A855F7"` |
| `background_color` | `"#0175C2"` | `"#0A0A0A"` |

---

## Files to Create

- [x] `lib/components/site_footer.dart` — shared site footer consumed by all page layouts
- [x] `lib/utils/tag_colors.dart` — `tagColor(String tag)` and `tagBgColor(String tag)` helpers
- [x] `web/404.html` — branded dark-theme 404 page

## Files to Modify

- [x] `lib/constants/theme.dart` — full replacement with dark design system tokens
- [x] `lib/main.server.dart` — title, fonts, global meta, JSON-LD Person schema
- [x] `web/manifest.json` — name, short_name, description, theme_color, background_color
- [x] `lib/components/counter.dart` — replaced stale `primaryColor` reference with `accentPurple`

---

## Acceptance Criteria

- [x] `lib/constants/theme.dart` exports all color, typography, spacing, and breakpoint constants
- [x] Global base styles in `theme.dart` remove the old Roboto import and set `bgBase` as body background
- [x] `lib/main.server.dart` uses `title: 'Andy Horn'`, imports Geist/Inter/Geist Mono fonts, has global `meta` defaults and JSON-LD Person schema
- [x] All pages have global fallback `<meta name="description">`, OG tags, and twitter card defaults in `<head>`
- [x] `web/404.html` exists with dark theme styling, `// 404` badge, and `← Back to Home` link
- [x] `web/manifest.json` has `name: "Andy Horn"`, `theme_color: "#A855F7"`, `background_color: "#0A0A0A"`
- [x] `lib/components/site_footer.dart` exists and renders the dark footer bar
- [x] `lib/utils/tag_colors.dart` exports `tagColor` and `tagBgColor` using theme constants
- [x] `jaspr build` produces a complete static site with no errors

---

## Testing Notes

- **Font loading**: after build, open `/` and verify Geist, Geist Mono, and Inter load (check Network tab for font requests)
- **SEO audit**: inspect `/`, `/blog`, and a post page HTML — verify `<title>`, `<meta name="description">`, OG tags, and JSON-LD are present on every page
- **404**: navigate to a non-existent path in a deployed environment (GitHub Pages / Netlify serves `404.html`) and verify the branded page appears
- **Theme smoke test**: verify `#0A0A0A` body background and `#A855F7` accent are applied consistently across pages

---

## References

- Design: `design.pen` — all color/font/spacing values extracted from this file
- Parent plan: `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md`
- Phase 2 plan: `docs/plan/2026-04-21-feat-portfolio-homepage-plan.md` — consumes these tokens
- Phase 3 plan: `docs/plan/2026-04-21-feat-blog-pages-content-plan.md` — consumes these tokens
