# Design Migration: current site → refreshed `design.pen`

This document maps the refreshed design in `design.pen` to the front-end code, so the
implementation can be migrated component-by-component in small, reviewable PRs.

The redesign's goal was to make the site read **less obviously templated / AI-generated**:
kill the color-flood hero, break up uniform card grids, replace generic copy with
concrete claims, drop the repeated `// section` badge motif, and favor asymmetric,
left-aligned composition over dead-centered symmetry.

## Source of truth

- File: `design.pen` (open in the Pencil editor to inspect).
- Frames:
  - **Portfolio – Desktop** — the home page (hero → stats → about → packages → blog preview → contact).
  - **Blog – List** — the `/blog` listing.
  - **Blog – Single Post** — a rendered post page.

The palette and type system are **unchanged** — every color/font already exists in
`lib/constants/theme.dart` (`bgBase #0A0A0A`, `accentPurple #A855F7`, `textMuted #A1A1AA`,
`bgSecondary #0D0D0D`, Geist / Inter / Geist Mono). No new tokens are required. This is a
layout + copy migration, not a re-theme.

## How to use this doc

Work top-to-bottom. Each section below names the **file**, the **current state**, the
**target state**, and **concrete steps**. Copy changes are given as explicit before → after
so text can be updated verbatim. Ship each numbered section as its own PR (see
[Suggested PR breakdown](#suggested-pr-breakdown)).

---

## 0. Cross-cutting: drop the `// section` badge motif

Every home section and the blog-list hero currently leads with a small purple
`.section-badge` chip (`// about me`, `// packages`, `// blog`, `// get in touch`). The
repetition of the identical chip is one of the clearest "generated" tells, so the redesign
removes **all** of them; the section heading now leads directly.

**Affected files & strings to remove:**

| File | Badge string to delete |
|------|------------------------|
| `lib/components/about_section.dart` | `// about me` |
| `lib/components/packages_section.dart` | `// packages` |
| `lib/components/blog_preview_section.dart` | `// blog` |
| `lib/components/contact_section.dart` | `// get in touch` (its own centered variant) |
| `lib/components/blog_interactive_section.dart` | `// blog` (blog-list hero) |

**Steps:**
1. In each file, remove the badge `div`/element from the `build` method.
2. Remove the now-unused per-section badge styles.
3. Remove the shared `.section-badge` rule from `globalStyles` in
   `lib/constants/theme.dart` once no component references it (grep to confirm zero uses).
4. Where the badge sat above a heading in a column with `gap`, verify the leading
   whitespace still looks intentional — no dangling top margin.

> The hero's `Open to collaboration` pill is a different element and is handled in §1
> (it is also removed).

---

## 1. Hero — `lib/components/hero_section.dart`

The single highest-impact change.

**Current:** full-bleed **solid purple** background, center-aligned, `Open to collaboration`
pill, a 72px three-line staccato headline `Flutter Engineer.` / `Package Author.` /
`App Builder.`, one translucent secondary button.

**Target (Portfolio – Desktop hero):** dark background (`bgBase`), **left-aligned single
column** with generous negative space on the right (no image/terminal/graphic — the empty
space is intentional). No badge. A larger two-tone headline, a rewritten subhead, and two
buttons (purple primary + ghost secondary).

**Copy changes:**

| Element | Before | After |
|---------|--------|-------|
| Badge | `Open to collaboration` | *(removed)* |
| Headline | `Flutter Engineer.` / `Package Author.` / `App Builder.` | `I build Flutter apps` / `and the open-source` / `packages under them.` |
| Subhead | `6+ years crafting high-quality Flutter apps and open-source packages. Focused on developer experience, clean architecture, and pixel-perfect UI.` | `Six years shipping polished mobile apps and the Dart packages that power them. Published on pub.dev, live on the App Store.` |
| Buttons | `Read the blog` (secondary only) | `Read the blog` (**primary**, purple fill) → `/blog`, and `View packages` (**secondary**, ghost) → `/#packages` |

**Headline two-tone:** line 1 is `textPrimary` (white); lines 2–3 are `accentPurple`. Since
each colored run is a separate line, render them as three spans/elements rather than one
`<br>`-delimited string, e.g. a `.hero__title` line for white and a `.hero__title--accent`
line for purple.

**Style changes:**
- `.hero &`: `background-color` → `bgBase`; `align-items` → `flex-start`;
  `text-align` → `left`; keep `min-height: 620px`, `justify-content: center`,
  horizontal padding `120px`. Constrain the text column (`max-width` ~820px) so the right
  side stays open.
- `.hero__title`: `72px` → `68px`, `letter-spacing: -2.5px`. Add the accent color variant.
- `.hero__sub`: color → `textMuted`; `max-width` ~560px.
- Buttons: wire up the already-defined `.hero__btn--primary` (currently unused —
  `background-color: bgBase`; change its fill to `accentPurple` with `bgBase` text) and add
  the second (ghost) button. Ghost = transparent fill + `1px solid #FFFFFF26`.
- Mobile: keep the existing stack behavior; drop title to ~44–48px.

**Worked example (before → after of the `build` method):**

```dart
// BEFORE
return section(classes: 'hero', [
  div(classes: 'hero__badge', [.text('Open to collaboration')]),
  h1(classes: 'hero__title', [
    .text('Flutter Engineer.'), br(),
    .text('Package Author.'), br(),
    .text('App Builder.'),
  ]),
  p(classes: 'hero__sub', [.text('6+ years crafting ...')]),
  div(classes: 'hero__btns', [
    a(href: '/blog', classes: 'hero__btn hero__btn--secondary', [.text('Read the blog')]),
  ]),
]);

// AFTER
return section(classes: 'hero', [
  h1(classes: 'hero__title', [
    span([.text('I build Flutter apps')]),
    span(classes: 'hero__title--accent', [.text('and the open-source')]),
    span(classes: 'hero__title--accent', [.text('packages under them.')]),
  ]),
  p(classes: 'hero__sub', [
    .text('Six years shipping polished mobile apps and the Dart packages '
          'that power them. Published on pub.dev, live on the App Store.'),
  ]),
  div(classes: 'hero__btns', [
    a(href: '/blog', classes: 'hero__btn hero__btn--primary', [.text('Read the blog')]),
    a(href: '/#packages', classes: 'hero__btn hero__btn--secondary', [.text('View packages')]),
  ]),
]);
```
(The `.hero__title` spans stack as block-level lines; give them `display: block`.)

---

## 2. Stats strip — `lib/components/stats_strip.dart`

**Current:** four stat/label pairs, the fourth being the joke stat `∞ / Cups of Coffee` —
a pure AI-copy tell.

**Target:** replace only the fourth pair. Everything else (layout, dividers, styling) is
unchanged.

| Before | After |
|--------|-------|
| `∞` / `Cups of Coffee` | `38k` / `Monthly Downloads` |

Update the `_stats` tuple list inline in the component.

> **Confirm the number.** `38k` is a placeholder chosen for the mock. Set it to a real
> aggregate (e.g. summed pub.dev monthly downloads across published packages) or a defensible
> figure before shipping.

---

## 3. About — `lib/components/about_section.dart`

**Current:** left column heading `Building beautiful` / `things with Flutter` (hollow
"beautiful things" copy) + `// about me` badge. Two-column with the experience timeline on
the right.

**Target:** concrete heading; badge removed (per §0). Bio, skill pills, and the timeline are
**unchanged** — they're already specific and real.

| Before | After |
|--------|-------|
| `Building beautiful` / `things with Flutter` | `From production apps` / `to pub.dev packages` |

The heading uses `white-space: pre-line` today, so keep the two-line break.

---

## 4. Packages — `lib/components/packages_section.dart` (+ `package_card.dart`)

The biggest structural change after the hero.

**Current:** header (`// packages` badge + `Open Source Packages` + subhead) over a uniform
**3-column grid** (`repeat(3, 1fr)`) of identical `PackageCard`s.

**Target (Portfolio – Desktop packages):** a **bento**: one **featured** package card (wide,
left) beside a **side column** holding the other two (stacked, right). Badge removed.

**Layout:**
- Replace the `grid-template-columns: repeat(3, 1fr)` container with a flex row: a featured
  card (≈1.4–1.6fr or fixed ~600px) + a side column (`flex: 1`) containing two compact cards.
- Responsive: under `breakpointMd`, stack featured-over-side-column; under `breakpointSm`,
  a single column.

**Featured card = `flutter_resizable_container`** (the most-downloaded package in
`lib/data/packages.dart`). It gets extra content the compact cards don't:
- a `Most popular` pill (green, `accentGreen`),
- a larger name + fuller description,
- a **stats row**: `LIKES` / `PUB POINTS` / `DOWNLOADS`,
- an install command chip: `$ flutter pub add flutter_resizable_container`.

**Compact cards** = `simple_routes` and `firebase_flavors`, roughly the current `PackageCard`
minus the description length, sized to fill the side column.

**Implementation options:**
- Add a `PackageCard.featured(...)` named constructor / `variant` flag to `package_card.dart`,
  or a sibling `FeaturedPackageCard`. Prefer extending the existing card so the live-data
  hydration (`@client` fetch of version + likeCount from the pub.dev API) is reused.

**Data wiring — read before shipping:**
- `likeCount` and latest `version` are already fetched client-side today; reuse them for the
  featured stats row (likes) and the install line.
- **Pub points** are available from the pub.dev score endpoint
  (`.../api/packages/<name>/score` → `grantedPoints`).
- **Downloads** are *not* in a convenient public pub.dev endpoint. Either omit the downloads
  stat, show a static maintained value, or drop it to two stats (likes + pub points). Do
  **not** ship an invented number. The mock's `243 / 160 / 31k` are illustrative only.

Header subhead copy is unchanged (`Dart and Flutter packages published on pub.dev, used by
developers worldwide.`), minus the badge.

---

## 5. Blog preview — `lib/components/blog_preview_section.dart`

**Current:** `// blog` badge + `Latest Writing` heading + `All posts →`, over a 3-column grid
of `BlogPreviewCard`.

**Target:** remove the badge only (per §0). The 3-card row is retained — it's small and reads
fine. No other change.

---

## 6. Contact — `lib/components/contact_section.dart`

**Current:** center-aligned column: `// get in touch` badge, 56px `Let's build something` /
`together`, subhead, `Connect on LinkedIn` button, a centered inline row of three links.

**Target (Portfolio – Desktop contact):** **left-aligned, two-column** band. Left column =
heading + subhead + primary button. Right column = the three links pulled into a **bordered
panel**.

**Copy changes:**

| Element | Before | After |
|---------|--------|-------|
| Badge | `// get in touch` | *(removed)* |
| Heading | `Let's build something` / `together` | `Let's build` / `something together` (re-broken; same words) |
| Subhead | `Open to collaboration on Flutter apps, open-source projects, and consulting engagements. Reach out — I respond within 24 hours.` | `Open to collaboration and open-source work. Find me on LinkedIn, GitHub, or pub.dev.` |
| Button | `Connect on LinkedIn` → `https://linkedin.com/in/andyjhorn` | *(unchanged)* |
| Links | linkedin.com/in/andyjhorn, github.com/andyhorn, pub.dev/publishers/andyhorn.dev | *(same links, restyled — see below)* |

> Note the subhead drops the "consulting engagements" and "respond within 24 hours" claims.
> Keep them only if they're true and you want them.

**Style changes:**
- `.contact &`: `align-items`/`text-align` center → `flex-start` / `left`; make the section a
  two-column flex (`justify-content: space-between`, `align-items: center`, gap ~80px,
  vertical padding ~120px).
- Left column: constrain heading (`max-width` ~560px) and subhead (~480px).
- Right column: wrap the three links in a panel — `background: bgSecondary`,
  `border: 1px solid borderDefault`, `border-radius: 12px`, `padding: 28px`, links stacked
  vertically (column, gap ~18px), each still an icon + text row.
- Mobile: stack to a single column (panel below the text).

---

## 7. Blog list — `lib/components/blog_interactive_section.dart`

**Target:** remove the `// blog` badge from `.blog-hero` (per §0). The hero heading
(`Writing on Flutter,\nDart & Software Craft`), subhead, search box, filters, featured/list
layout, and `BlogSidebar` are **unchanged** — this screen was already left-aligned with real
hierarchy.

---

## 8. Blog post — `lib/pages/blog/blog_post.dart`

**No required changes.** The design's Single-Post frame originally carried a placeholder
byline ("Andrew Dev / andrewdev.io"); that was corrected in `design.pen` to match the code,
which already uses **Andy Horn** (visible byline is `{date} · {reading time}`, and the JSON-LD
author is `Andy Horn`).

**Optional (design-only enhancement, low priority):** the mock shows an author block
(avatar + name + handle) under the post title that the current code does not render. Add it
only if desired; it is not part of the "de-AI" migration.

---

## Data & orphaned code

- `lib/data/packages.dart` — no structural change; the featured/compact split in §4 is a
  presentation decision over the same 3 entries. `flutter_resizable_container` is the featured
  one.
- Stats (`stats_strip.dart`) and skills (`about_section.dart`) remain inline; only the one
  stat value changes (§2).
- `apps_section.dart` + `app_card.dart` + `lib/data/apps.dart` are fully built but **not
  mounted** anywhere. The redesign does not use them. Out of scope here, but flag for a
  separate decision: **mount or delete**. (Leaving dead, unmounted feature code is itself a
  mild "generated scaffolding" smell.)

## Explicitly out of scope

- Header (`header.dart`) and footer (`site_footer.dart`) — unchanged.
- The palette, fonts, and theme tokens — unchanged.
- Adding a hero photo / device mockup — the hero right side is intentionally empty negative
  space in this design.

## Decisions to confirm before/while implementing

1. **Stats value** — real "Monthly Downloads" figure to replace the `38k` placeholder (§2).
2. **Featured package stats** — which of likes / pub points / downloads to show, given the
   downloads data gap (§4).
3. **Contact subhead** — keep or drop the removed "consulting / 24 hours" claims (§6).
4. **Orphaned `AppsSection`** — mount it or delete it (separate PR either way).

## Verification checklist (per PR)

- [ ] `jaspr serve` and visually compare the changed section against its `design.pen` frame
      at desktop (1440) and mobile (≤ `breakpointMd`, 768) widths.
- [ ] No leftover references to removed classes (`grep -r "section-badge"`, per-badge classes).
- [ ] `dart analyze` is clean.
- [ ] `dart test` passes.
- [ ] `dart run tool/generate_routes.dart` **only** if posts changed (not needed for these
      component edits).

## Suggested PR breakdown

Small, conventional-commit-sized changes, ordered by impact and independence:

1. `refactor: drop // section badges across home + blog` (§0) — mechanical, touches many files.
2. `feat: redesign hero — dark, left-aligned, two-tone headline` (§1) — highest impact.
3. `feat: bento layout for packages with featured card` (§4) — most new code; may split into
   `feat: add featured package card variant` + `refactor: packages bento layout`.
4. `feat: two-column left-aligned contact section` (§6).
5. `style: concrete about heading` (§3) + `content: real monthly-downloads stat` (§2) — tiny,
   can combine.
6. `chore: decide on orphaned AppsSection` (separate, optional).
