# feat: portfolio homepage sections

**Type:** Enhancement  
**Date:** 2026-04-21  
**Complexity:** Standard  
**Phase:** 2 of 3  
**Parent plan:** `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md` (original Phase 3)  
**Depends on:** data layer & routing (complete); Phase 1 for `SiteFooter` and `lib/utils/tag_colors.dart` (build Phase 1 shared-chrome tasks first)  
**Independent of:** `feat-blog-pages-content-plan.md`

> **Note:** This plan supersedes the original Phase 3 plan after the `design.pen` design review. The homepage is 10 sections (not 5), uses a dark purple design system, and requires data model amendments (see below) before any component work begins.

---

## Summary

Rewrite `lib/pages/home.dart` from the current scaffold (Counter widget) into a full portfolio homepage with 10 sections matching the design: Nav, Hero, Bridge Container, Stats Strip, About, Apps, Packages, Blog Preview, Contact, and Footer. Rebuild `lib/components/header.dart` to match the design nav (logo left, links center, CTA right). Amend the data models to match the design: rename `Project` → `App` with image/badge-color fields, and `Skill` → `Package` with version/stars/pub.dev fields.

---

## Background

The data layer and routing are complete. The homepage renders a placeholder with a Counter widget. The data layer created `Project` and `Skill` models that do not match the design — they need amendment before this plan can be fully built.

The design (`design.pen`) shows a dark-theme portfolio with:
- Background `#0A0A0A`, card surfaces `#111111`, secondary bg `#0D0D0D`
- Primary accent `#A855F7` (purple)
- Fonts: Geist (headings), Geist Mono (code/badges), Inter (body/nav)

**Key constraints:**
- `home.dart` currently has `@client` annotation and imports `Counter` — both must be removed
- Nav hash links (`#about`, `#apps`, `#packages`) are for in-page scroll on the homepage; from other pages they use `/#about` etc.
- All section components are purely static (no client-side state)
- App card images (`images/generated-*.png`) are referenced from the design; use placeholder `<div>` with colored bg until real screenshots exist

---

## Model Amendments (prerequisite)

Before building homepage components, amend the data models:

### `lib/models/app.dart` (new file, replaces `project.dart`)

```dart
class App {
  const App({
    required this.title,
    required this.description,
    required this.storeUrl,
    required this.tags,
    required this.imageUrl,  // path to screenshot image, e.g. 'images/focus-flow.png'
    required this.badgeColor, // hex string for the App Store badge accent, e.g. '#A855F7'
  });

  final String title;
  final String description;
  final String storeUrl;
  final List<String> tags;
  final String imageUrl;
  final String badgeColor;
}
```

### `lib/models/package.dart` (new file, replaces `skill.dart`)

```dart
class Package {
  const Package({
    required this.name,
    required this.description,
    required this.version,
    required this.stars,
    required this.pubDevUrl,
    required this.iconColor, // hex string, e.g. '#A855F7'
  });

  final String name;
  final String description;
  final String version;
  final int stars;
  final String pubDevUrl;
  final String iconColor;
}
```

### `lib/data/apps.dart` (new file, replaces `projects.dart`)

```dart
// 4 apps from design.pen
const apps = [
  App(
    title: 'FocusFlow',
    description: 'A minimalist productivity app with Pomodoro timers, task management, and focus sessions. Built with Flutter & Bloc.',
    storeUrl: 'https://apps.apple.com/...',
    tags: ['Flutter', 'Productivity'],
    imageUrl: 'images/focus-flow.png',
    badgeColor: '#A855F7',
  ),
  App(title: 'TrailMapper', description: 'Offline-first hiking trail app with GPX track recording, elevation charts, and waypoints.', storeUrl: 'https://apps.apple.com/...', tags: ['Flutter', 'Outdoor'], imageUrl: 'images/trail-mapper.png', badgeColor: '#3B82F6'),
  App(title: 'BudgetPal', description: 'Smart personal finance tracker with categories, charts, and monthly budget goals.', storeUrl: 'https://apps.apple.com/...', tags: ['Flutter', 'Finance'], imageUrl: 'images/budget-pal.png', badgeColor: '#10B981'),
  App(title: 'DailyLens', description: 'A photo journaling app with AI tagging, timeline view, and private encrypted albums.', storeUrl: 'https://apps.apple.com/...', tags: ['Flutter', 'Photography'], imageUrl: 'images/daily-lens.png', badgeColor: '#F59E0B'),
];
```

### `lib/data/packages.dart` (new file, replaces `skills.dart`)

```dart
// 3 packages from design.pen
const packages = [
  Package(name: 'flutter_animated_list', description: 'Animated list widget with staggered entry/exit transitions. Drop-in replacement for ListView.', version: 'v2.1.0', stars: 240, pubDevUrl: 'https://pub.dev/packages/flutter_animated_list', iconColor: '#A855F7'),
  Package(name: 'dart_result', description: 'Railway-oriented Result type for Dart. Elegant error handling without exceptions.', version: 'v1.4.2', stars: 187, pubDevUrl: 'https://pub.dev/packages/dart_result', iconColor: '#3B82F6'),
  Package(name: 'bloc_navigator', description: 'Declarative navigation for Bloc-based Flutter apps using GoRouter under the hood.', version: 'v3.0.1', stars: 412, pubDevUrl: 'https://pub.dev/packages/bloc_navigator', iconColor: '#10B981'),
];
```

> **Keep** `lib/models/project.dart` and `lib/models/skill.dart` in place during this phase — remove them only after verifying no other files import them (run `dart analyze`). The new `App` and `Package` models live in new files.

---

## Files to Create

- [ ] `lib/models/app.dart` — `App` data class
- [ ] `lib/models/package.dart` — `Package` data class
- [ ] `lib/data/apps.dart` — `apps` const list (4 entries)
- [ ] `lib/data/packages.dart` — `packages` const list (3 entries)
- [ ] `lib/components/hero_section.dart`
- [ ] `lib/components/bridge_section.dart` — decorative code snippet card (static)
- [ ] `lib/components/stats_strip.dart`
- [ ] `lib/components/about_section.dart`
- [ ] `lib/components/apps_section.dart`
- [ ] `lib/components/app_card.dart` — renders a single `App`
- [ ] `lib/components/packages_section.dart`
- [ ] `lib/components/package_card.dart` — renders a single `Package`
- [ ] `lib/components/blog_preview_section.dart` — receives `List<Post>`, renders 3-col grid
- [ ] `lib/components/blog_preview_card.dart` — renders a single post preview card
- [ ] `lib/components/contact_section.dart`

## Files to Modify

- [ ] `lib/components/header.dart` — full rewrite to match design nav (see sketch below)
- [ ] `lib/pages/home.dart` — full rewrite (see sketch below)
- [ ] `lib/app.dart` — pass `posts.take(3).toList()` to `Home` for blog preview section

## Files to Delete

- [ ] `lib/pages/about.dart` — route was removed in the routing phase; now dead code

---

## Component Sketches

### `lib/components/header.dart` — nav rebuild

```dart
// Design: logo left | 4 links center | CTA right
// Active link: purple #A855F7, fw600 (no underline)
// Nav links About/Apps/Packages are hash anchors; Blog is a router link

class Header extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final path = context.url;

    return header([
      // navLogo
      a(href: '/', [text('andyhorn.dev')]),
      // navLinks: About, Apps, Packages → hash anchors; Blog → router Link
      nav([
        a(href: '/#about', [text('About')]),
        a(href: '/#apps',  [text('Apps')]),
        a(href: '/#packages', [text('Packages')]),
        div(classes: path.startsWith('/blog') ? 'active' : null, [
          Link(to: '/blog', child: .text('Blog')),
        ]),
      ]),
      // navCta
      a(href: '/#contact', classes: 'nav-cta', [text('Get in touch')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // header: full-width, space-between, 72px height, bg #0A0A0A
    // navLogo: Geist 700 20px, white, letter-spacing -0.5px
    // nav: flex, gap 40px
    // nav a: Inter 400 15px, color #A1A1AA, no underline
    // nav div.active a: color #A855F7, font-weight 600
    // .nav-cta: pill bg #A855F7, color #0A0A0A, Inter 600 14px, h38, px20
  ];
}
```

### `lib/pages/home.dart`

```dart
class Home extends StatelessComponent {
  const Home({super.key, required this.recentPosts});
  final List<Post> recentPosts;

  @override
  Component build(BuildContext context) {
    return Document.head(
      title: 'Andy Horn — Flutter Engineer & Package Author',
      meta: {
        'description': 'Portfolio and blog of Andy Horn, Flutter engineer and pub.dev package author.',
        'og:title': 'Andy Horn — Flutter Engineer',
        'og:type': 'website',
      },
      child: div([
        const HeroSection(),
        const BridgeSection(),
        const StatsStrip(),
        const AboutSection(),
        const AppsSection(),
        const PackagesSection(),
        BlogPreviewSection(posts: recentPosts),
        const ContactSection(),
        const SiteFooter(),
      ]),
    );
  }
}
```

> `lib/app.dart` must be updated to pass `posts.take(3).toList()` to `Home`.

### `lib/components/hero_section.dart`

```
// Purple bg #A855F7, 620px height, centered vertical layout, padding 80/120/160/120
// Children:
//   heroBadge: "Open to collaboration" pill (Geist Mono 12, bg #00000020, rounded-full)
//   heroTitle: "Flutter Engineer.\nPackage Author.\nApp Builder." (Geist 72 700, white, lh 1.05, ls -2)
//   heroSub: "5+ years crafting..." (Inter 18, #FFFFFFCC, lh 1.6, center, maxWidth 600)
//   heroBtns row:
//     primary: "View my work" → href="/#apps" (dark bg #0A0A0A, pill, Inter 600 15, white)
//     secondary: "Read the blog" → href="/blog" (bg #FFFFFF20, border #FFFFFF40, pill, Inter 600 15, white)
```

### `lib/components/bridge_section.dart`

```
// Decorative code snippet card — purely visual, no interaction
// Outer: 1200px max-width, bg #141414, radius 8, shadow (y8 blur40 #00000040) + glow (blur80 #A855F720)
// Two panes side by side with gap 2:
//   Left (#111111): "main.dart" badge (Geist Mono 11, purple bg #A855F720), then Geist Mono 14 code lines
//   Right (#0F0F0F): "pubspec.yaml" badge, then Geist Mono 14 code lines
```

### `lib/components/stats_strip.dart`

```
// Full-width, h100, bg #0D0D0D, border #1A1A1A
// 4 stats separated by 1px dividers (#1A1A1A), space_between, px 120
// Each stat: value (Geist Mono 32 700 purple #A855F7) + label (Inter 13 muted #A1A1AA)
// Values: "5+", "20+", "4", "∞"
// Labels: "Years Experience", "pub.dev Packages", "Published Apps", "Cups of Coffee"
```

### `lib/components/about_section.dart`

```
// bg #0A0A0A, 2-col, py 100 px 120, gap 80
// Left col (fill):
//   badge: "// about me" (Geist Mono 12, purple bg #A855F715, radius 4)
//   heading: "Building beautiful\nthings with Flutter" (Geist 48 700, white, lh 1.1, ls -1.5)
//   bio: "I'm a software engineer..." (Inter 16, muted #A1A1AA, lh 1.7, maxWidth 500)
//   skill pills row: Flutter, Dart, pub.dev, Firebase
//     each pill: bg #1A1A1A, border #2A2A2A, rounded-full, h32, px14 (Geist Mono 13, white)
// Right col (480px):
//   expCard: bg #111111, border #1A1A1A, radius 8, p24, v-layout gap 8
//     date: "2019 – Present" (Geist Mono 12, purple)
//     title: "Senior Flutter Engineer" (Geist 18 fw600, white)
//     desc: "Building cross-platform apps..." (Inter 14, muted, lh 1.6, maxWidth 400)
```

### `lib/components/app_card.dart`

```
// Card: bg #111111, border #1A1A1A, radius 8, clip, vertical layout
// app.imageUrl as cover img, height 200px (use colored placeholder div if no image)
// App Store badge pill: h24, rounded-full, bg = app.badgeColor + "30", text = app.badgeColor
//   label: "App Store" (Geist Mono 10)
// Body (p24, v-layout gap 8):
//   title: app.title (Geist 22 700, white)
//   desc: app.description (Inter 14, muted, lh 1.6, maxWidth 260)
// Entire card wraps as <a href="app.storeUrl"> (or div if no URL)
```

### `lib/components/package_card.dart`

```
// Card: bg #111111, border #1A1A1A, radius 8, p24, v-layout gap 16
// Top row (space_between):
//   icon: 40×40 box, bg = pkg.iconColor + "20", radius 8, centered icon glyph (●) or SVG
//   stars: amber star (⭐) + star count in Geist Mono 12 muted
// name: pkg.name (Geist Mono 15 fw600, white)
// desc: pkg.description (Inter 13, muted, lh 1.6)
// footer row: version (Geist Mono 11, pkg.iconColor) · "pub.dev" (Inter 11, muted) → href pkg.pubDevUrl
```

### `lib/components/blog_preview_section.dart`

```
// bg #0D0D0D, py 100 px 120, v-layout gap 48
// Header row (space_between):
//   left: "// blog" badge + "Latest Writing" (Geist 40 700)
//   right: "All posts →" ghost button → Link(to: '/blog')
// 3-col grid of BlogPreviewCard(post: post)
```

### `lib/components/blog_preview_card.dart`

```
// Card: bg #111111, border #1A1A1A, radius 8, p32, v-layout gap 20
// meta row: date (Geist Mono 12 muted) | 1px divider | tag pill (color by tag)
// title: post.meta.title (Geist 20 700, white, lh 1.3, maxWidth 340)
// excerpt: post.meta.description (Inter 14, muted, lh 1.6)
// "Read more" link: purple #A855F7, Inter 600 14, with → arrow
// Entire card links to /blog/post.meta.slug
```

### Tag color system

Used in blog preview cards and blog list page:

| Tag | Color | Bg |
|-----|-------|-----|
| Flutter | `#A855F7` | `#A855F720` |
| Dart | `#3B82F6` | `#3B82F620` |
| Architecture | `#10B981` | `#10B98120` |
| Open Source | `#F59E0B` | `#F59E0B20` |
| DevX | `#10B981` | `#10B98120` |
| (default) | `#A1A1AA` | `#A1A1AA20` |

Defined as `tagColor(String tag)` / `tagBgColor(String tag)` in `lib/utils/tag_colors.dart` — **created in Phase 1; import from there**.

### `lib/components/contact_section.dart`

```
// bg #0A0A0A, py 100 px 120, v-layout gap 40, items center
// "// get in touch" badge (Geist Mono 12, purple, bg #A855F715, radius 4)
// "Let's build something\ntogether" (Geist 56 700, white, lh 1.05, ls -2, center, maxWidth 700)
// sub: "Open to collaboration..." (Inter 17, muted, lh 1.7, center, maxWidth 500)
// primary CTA: <a> "Connect on LinkedIn" → purple bg #A855F7, pill, h54, px32, Inter 600 15, dark text
// secondary links row (gap 24): LinkedIn url, GitHub url, pub.dev url (Inter 14 muted each)
```

### `lib/components/site_footer.dart` _(created in Phase 1 — import from there)_

```
// bg #0D0D0D, border-top #1A1A1A, h72, px 120, space_between, items center
// left: "© 2025 andyhorn.dev. Built with Flutter." (Geist Mono 13, muted)
// right links (gap 32): Privacy, RSS, Source (Inter 13, muted)
```

### JSON-LD Person schema (in `lib/pages/home.dart`)

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
)
```

---

## Acceptance Criteria

- [ ] Model amendments: `lib/models/app.dart`, `lib/models/package.dart`, `lib/data/apps.dart`, `lib/data/packages.dart` exist and compile
- [ ] `/` renders all 10 sections: Nav, Hero, Bridge, Stats, About, Apps, Packages, Blog Preview, Contact, Footer
- [ ] Nav: logo left "andyhorn.dev", 4 links center, "Get in touch" pill CTA right; active Blog link turns purple fw600
- [ ] Hero: purple background, correct title copy, two CTA buttons with correct `href` targets
- [ ] Stats strip: 4 stats with correct values/labels
- [ ] About section: 2-col layout, skill pills, experience card on right
- [ ] Apps section: 4 cards with per-app badge colors
- [ ] Packages section: 3 cards with icon, stars, version, pub.dev link
- [ ] Blog Preview: 3 most recent posts with tag-color pills; "All posts →" links to `/blog`
- [ ] Contact: LinkedIn CTA, secondary social links
- [ ] Footer: copyright left, links right
- [ ] `home.dart` has no `@client` annotation or `Counter` import
- [ ] `lib/pages/about.dart` is deleted
- [ ] `jaspr build` completes without errors

---

## Testing Notes

- Verify `#about`, `#apps`, `#packages`, `#contact` anchors exist in built HTML (required for nav hash links to work)
- Check that `lib/pages/about.dart` deletion leaves no dangling imports (`dart analyze`)
- After `jaspr build`, open `/` and confirm all sections render in order
- Inspect `<head>` for `<title>`, `<meta name="description">`, and `<script type="application/ld+json">`
- Confirm old `project.dart`/`skill.dart` no longer imported anywhere before deleting them

---

## References

- Design: `design.pen` frames `VA0Et` (Portfolio – Desktop)
- Parent plan: `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md`
- Phase 1 plan: `docs/plan/2026-04-21-feat-global-polish-seo-plan.md` — design token definitions
