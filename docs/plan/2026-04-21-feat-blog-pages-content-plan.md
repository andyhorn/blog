# feat: blog pages full content and SEO

**Type:** Enhancement  
**Date:** 2026-04-21  
**Complexity:** Standard  
**Phase:** 3 of 3  
**Parent plan:** `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md` (original Phase 4)  
**Depends on:** data layer & routing (complete); Phase 1 for `SiteFooter` and `lib/utils/tag_colors.dart` (build Phase 1 shared-chrome tasks first)  
**Independent of:** `feat-portfolio-homepage-plan.md`

> **Note:** This plan supersedes the original Phase 4 plan after `design.pen` review. The blog list page has a richer layout (hero + filters + featured post + post list + sidebar) that differs from the original spec. Interactive elements (search, filters, pagination) are **visual-only** in v1 — this is a static Jaspr site with no client-side JS.

---

## Summary

Flesh out `blog_list.dart` and `blog_post.dart` with full content matching the design. The blog list page renders: a hero section, a visual-only filters strip, a 2-column body (main + sidebar), where main shows a featured post card followed by a list of post rows and visual-only pagination. The sidebar shows an author bio card and a topics tag card. Blog post pages render the post content with SEO, per-post JSON-LD, and syntax highlighting via highlight.js.

---

## Background

The data layer and routing are complete. `lib/pages/blog/blog_list.dart` renders only `<h1>` + post `<h2>` titles. `lib/pages/blog/blog_post.dart` renders title + raw HTML. Both need full rewrites.

**Static site constraint**: Search bar, filter pills, and pagination buttons are rendered as HTML but have no client-side behavior. They are visual scaffolding only — functionality can be added in a future phase if the framework is extended with client components.

**Featured post**: The first post when sorted newest-first is the featured post. It receives larger treatment (horizontal card with image placeholder, "★ Featured" badge).

**Tag color system**: Tags use semantic accent colors (see Phase 2 plan for full mapping). A shared `lib/utils/tag_colors.dart` provides `tagColor(String tag)`.

---

## Implementation Tasks

### `lib/pages/blog/blog_list.dart` — full rewrite

- [x] Sort posts by `meta.date` descending
- [x] Featured post = `posts.first` (if posts non-empty); remaining posts = `posts.skip(1).toList()`
- [x] Render in order: BlogHero → Filters → BlogBody
- [x] Empty state in place of BlogBody: `<p>No posts yet — check back soon.</p>` inside the body area

### `lib/pages/blog/blog_post.dart` — full rewrite

- [x] Render nav header + post content + footer
- [x] Per-post `Document.head(...)` with title, description, OG tags, canonical link, and JSON-LD BlogPosting schema

### `lib/main.server.dart` — add highlight.js

- [x] Add highlight.js CSS `<link>` to `Document(head: [...])`
- [x] Add highlight.js `<script>` tag and `hljs.highlightAll()` init script

---

## Files to Create

- [x] `lib/components/blog_hero.dart` — blog page hero (not the homepage blog preview)
- [x] `lib/components/blog_filters.dart` — visual-only filter pills strip
- [x] `lib/components/featured_post_card.dart` — horizontal large card for the most recent post
- [x] `lib/components/post_list_row.dart` — compact row for the "All Posts" list
- [x] `lib/components/blog_sidebar.dart` — sidebar with author bio + topics cards

---

## Component Sketches

### `lib/pages/blog/blog_list.dart`

```dart
class BlogListPage extends StatelessComponent {
  const BlogListPage({super.key, required this.posts});
  final List<Post> posts;

  @override
  Component build(BuildContext context) {
    final sorted = [...posts]..sort((a, b) => b.meta.date.compareTo(a.meta.date));
    final featured = sorted.isNotEmpty ? sorted.first : null;
    final rest = sorted.length > 1 ? sorted.skip(1).toList() : <Post>[];

    return Document.head(
      title: 'Blog | Andy Horn',
      meta: {'description': 'Writing on Flutter, Dart, and software craft.'},
      child: div([
        const Header(),
        BlogHero(),
        BlogFilters(),
        featured != null
            ? BlogBody(featured: featured, posts: rest)
            : div(classes: 'blog-empty', [text('No posts yet — check back soon.')]),
        const SiteFooter(),
      ]),
    );
  }
}
```

### `lib/components/blog_hero.dart`

```
// bg #0D0D0D, border-bottom #1A1A1A, py 80 px 120, v-layout gap 20
// blHeroBadge: "// blog" (Geist Mono 12, purple, bg #A855F715, radius 4)
// title: "Writing on Flutter,\nDart & Software Craft" (Geist 56 700, white, lh 1.05, ls -2, maxWidth 800)
// sub: "Thoughts on building apps, open-source packages..." (Inter 17, muted #A1A1AA, lh 1.6, maxWidth 560)
// search box (visual-only):
//   div: w560 h52, bg #111111, border #2A2A2A, radius 8, flex row gap 12, px 20, items center
//   icon: 🔍 or SVG search icon (18px, muted)
//   placeholder text: "Search posts…" (Inter 15, color #3A3A3A)
//   NOTE: no <input> — this is a static decorative element only
```

### `lib/components/blog_filters.dart`

```
// Full-width h56, bg #0D0D0D, border-top + border-bottom #1A1A1A
// flex row, gap 12, px 120, items center
// "Filter:" label (Geist Mono 12, muted)
// "All" pill: bg #A855F7, text #0A0A0A, rounded-full h30, px14 (Geist Mono 12 fw600) — shown as active
// Inactive pills: Flutter, Dart, Architecture, Open Source, DevX
//   each: bg #1A1A1A, border #2A2A2A, rounded-full h30, px14, text muted (Geist Mono 12)
// NOTE: pills are <span> or <div> elements — no click handlers. Visual only in v1.
```

### `lib/components/featured_post_card.dart`

```
// Horizontal card: bg #111111, border #1A1A1A, radius 8, clip, flex row
// Left image area: 436×315px, bg = placeholder colored div (no real images needed at this stage)
// Right content (fill, p32, v-layout gap 16):
//   meta row (gap 12, items center):
//     tag pill (tag-color system)
//     "★ Featured" badge: bg #F59E0B20, text #F59E0B, Geist Mono 10, radius 4, h24, px10
//     date: Geist Mono 12 muted · reading time: Inter 12 muted
//   title: post.meta.title (Geist 26 700, white, lh 1.2)
//   excerpt: post.meta.description (Inter 15, muted, lh 1.65)
//   "Read post →" link: purple Inter 600 14, arrow-right icon — href /blog/post.meta.slug
```

### `lib/components/post_list_row.dart`

```
// Row in the "All Posts" list container
// Container is bg #111111, border #1A1A1A, radius 8, clip, v-layout gap 1 (rows separated by 1px dividers)
// Each row: h88, flex row, px24, gap 16, items center
// Left (fill):
//   tags row (gap 8): tag pill(s) — colored by tag-color system, h20, radius 4, Geist Mono 10
//   title: post.meta.title (Geist 16 fw600, white)
// Right (end-aligned, v-layout gap 4):
//   date: Geist Mono 12 muted
//   reading time: Inter 12 muted
// Entire row wraps as <a href="/blog/post.meta.slug">
```

### `lib/components/blog_sidebar.dart`

```
// Width 280, v-layout gap 24
// sideAbout card: bg #111111, border #1A1A1A, radius 8, p24, v-layout gap 16
//   "About the author" (Geist 14 700, white)
//   bio: "Flutter engineer & package author..." (Inter 13, muted, lh 1.6)
//   social icons row (gap 12): GitHub circular icon (32×32, bg #1A1A1A), LinkedIn circular icon
// sideTags card: bg #111111, border #1A1A1A, radius 8, p24, v-layout gap 16
//   "Topics" (Geist 14 700, white)
//   tag pills: Flutter, Dart, Architecture, Open Source, DevX — static, same colors as filter strip
```

### Blog body layout

```
// BlogBody: flex row, gap 48, px 120, py 64, bg #0A0A0A
// blMain (fill):
//   FeaturedPostCard(post: featured)
//   "All Posts" heading: Geist 22 700, white
//   Post list container (v-layout gap 1, radius 8):
//     for each post in rest: PostListRow(post: post)
//   Pagination (visual-only): flex row, center, gap 8
//     "Prev" button: bg #111111, border #1A1A1A, radius 6, h38 px16
//     Page 1 (active): bg #A855F7, radius 6, 38×38, Geist Mono 13 fw600 white
//     Pages 2, 3 (inactive): bg #111111, border #1A1A1A, radius 6, 38×38, Geist Mono 13 muted
//     "Next" button: same as Prev
//     NOTE: all pagination elements are non-interactive in v1
// blSidebar: BlogSidebar() — 280px fixed width
```

### `lib/pages/blog/blog_post.dart`

```dart
class BlogPostPage extends StatelessComponent {
  const BlogPostPage({super.key, required this.post});
  final Post post;

  @override
  Component build(BuildContext context) {
    return Document.head(
      title: '${post.meta.title} | Andy Horn',
      meta: {
        'description': post.meta.description,
        'og:title': post.meta.title,
        'og:description': post.meta.description,
        'og:type': 'article',
        'og:url': 'https://andyhorn.dev/blog/${post.meta.slug}',
        'twitter:card': 'summary_large_image',
      },
      child: div([
        const Header(),
        main_([
          // Back link
          Link(to: '/blog', child: .text('← Back to Blog')),
          // Post header
          h1([text(post.meta.title)]),
          // Byline: date · reading time
          div(classes: 'post-byline', [
            text('${formatDate(post.meta.date)} · ${post.meta.readingTimeMinutes} min read'),
          ]),
          // Tag pills
          div(classes: 'post-tags', [
            for (final tag in post.meta.tags)
              span(classes: 'tag tag-${tag.toLowerCase()}', [text(tag)]),
          ]),
          // Content
          div(classes: 'post-content', [RawText(post.htmlContent)]),
          // JSON-LD BlogPosting schema
          script(
            attributes: {'type': 'application/ld+json'},
            [RawText(jsonEncode({...}))],
          ),
        ]),
        const SiteFooter(),
      ]),
    );
  }
}
```

### JSON-LD BlogPosting schema

```dart
script(
  attributes: {'type': 'application/ld+json'},
  [RawText(jsonEncode({
    '@context': 'https://schema.org',
    '@type': 'BlogPosting',
    'headline': post.meta.title,
    'description': post.meta.description,
    'datePublished': post.meta.date.toIso8601String(),
    'author': {'@type': 'Person', 'name': 'Andy Horn', 'url': 'https://andyhorn.dev'},
    'url': 'https://andyhorn.dev/blog/${post.meta.slug}',
  }))],
)
```

### Date formatting helper

```dart
// lib/utils/format_date.dart
// Check pubspec.yaml for `intl` first; if absent, use manual month list
String formatDate(DateTime date) {
  const months = ['January','February','March','April','May','June',
                  'July','August','September','October','November','December'];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
```

### highlight.js in `lib/main.server.dart`

```dart
// In Document(head: [...]):
link(
  attributes: {'rel': 'stylesheet', 'href': 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css'},
),
script(attributes: {'src': 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js'}),
script([RawText('hljs.highlightAll();')]),
```

> Use the `github-dark` highlight.js theme to match the dark site palette.

---

## Acceptance Criteria

- [x] `/blog` renders: hero, visual-only search box, visual-only filter pills, featured post card, "All Posts" list, visual-only pagination, sidebar
- [x] Featured post card = newest post; "All Posts" list shows remaining posts sorted newest-first
- [x] `/blog` shows "No posts yet — check back soon." when `posts` is empty
- [x] `/blog/:slug` renders correct post with full markdown HTML content
- [x] `/blog/:slug` shows byline (date + reading time), tag pills, "← Back to Blog" link
- [x] `/blog` and `/blog/:slug` each have unique `<title>` and `<meta name="description">`
- [x] Blog post pages have Open Graph tags and JSON-LD `BlogPosting` schema
- [x] Code blocks in posts are syntax-highlighted via highlight.js with `github-dark` theme
- [x] `jaspr build` completes without errors

---

## Testing Notes

- **Build pipeline**: add `content/posts/2026-04-20-hello-world.md` → run `dart run tool/generate_routes.dart` → `jaspr build` → verify post appears at `/blog/hello-world`
- **Featured post**: add 2+ posts — verify the newest appears in the large featured card and the rest appear in the post list rows
- **Empty state**: remove all posts → run codegen → verify `/blog` shows empty state message
- **SEO audit**: inspect built HTML for `/blog` and a post page — verify unique `<title>`, `<meta name="description">`, OG tags, and JSON-LD in `<head>`
- **highlight.js**: add a fenced code block to a post and confirm `github-dark` syntax coloring applies in the browser

---

## References

- Design: `design.pen` frame `331Y7` (Blog – List)
- [highlight.js CDN](https://highlightjs.org/download)
- Parent plan: `docs/plan/2026-04-20-feat-personal-portfolio-blog-plan.md`
- `lib/models/post.dart` — `Post`, `PostMeta` data classes already complete
