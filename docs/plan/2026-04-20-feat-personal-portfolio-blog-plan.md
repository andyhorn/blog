# feat: add personal portfolio and blog

**Type:** Enhancement  
**Date:** 2026-04-20  
**Complexity:** Standard  

---

## Summary

Transform the current Jaspr scaffold into a fully-featured personal portfolio and blog. The site will have a portfolio homepage (Hero, About, Projects, Skills, Socials) and a markdown-driven blog (listing + individual post pages). All built on the existing Jaspr static-mode foundation with jaspr_router.

---

## Background

The repository is a Jaspr static site (mode: `static`, flutter: `embedded`) with two placeholder pages (`/` and `/about`), a nav header, and a `markdown: ^7.3.1` dependency already present. The project uses:

- **Framework**: Jaspr `^0.23.0` — server-side pre-rendering, static output
- **Routing**: jaspr_router `^0.8.2`
- **Styling**: CSS-in-Dart via `@css` annotations
- **Build**: `jaspr build` via `build_runner`

The `markdown` dep signals intent for a blog pipeline. No blog infrastructure exists yet.

---

## Open Decisions (resolve before building)

| # | Question | Default Assumption |
|---|---|---|
| 1 | **Hosting target** — affects 404 handling | Create `web/404.html` as universal fallback |
| 2 | **Hero CTA destination** | Scroll to Projects section via hash link (`/#projects`) |
| 3 | **Socials to display** | GitHub, LinkedIn, Twitter/X, Email — as icon links in a Socials section at the bottom of the homepage |
| 4 | **Projects / Skills data source** | Dart constants in `lib/data/` (editable without a content pipeline) |
| 5 | **Tag filtering** | Non-interactive labels in v1; no tag pages |
| 6 | **Code syntax highlighting** | Client-side highlight.js injected via `<script>` tag |
| 7 | **RSS feed** | Not in v1 |

---

## Architecture

### Route Map (final)

```
/               → Home (Hero + About + Projects + Skills + Socials sections)
/blog           → Blog listing (all posts, date-descending)
/blog/:slug     → Individual post (pre-generated at build time)
*               → 404 (web/404.html served by host)
```

The existing `/about` route is **removed**. Its content becomes the About section on the homepage. There is no separate contact page — social links are displayed in a Socials section at the bottom of the homepage.

### Blog Content Pipeline

**Approach: Manual pipeline (Path B)** — keeps full control over layout and avoids replacing the entire App structure that the portfolio pages need.

```
content/
  posts/
    2026-04-20-hello-world.md      → /blog/hello-world
    2026-05-01-building-with-jaspr.md → /blog/building-with-jaspr
```

File naming convention: `YYYY-MM-DD-slug.md` (date prefix for easy sorting; slug derived by stripping the date).

**Frontmatter schema:**
```yaml
---
title: "Hello World"
date: "2026-04-20"
description: "My first post on the new site."
tags: ["Dart", "Jaspr"]
---
```

**Build-time route discovery**: A Dart script (`tool/generate_routes.dart`) scans `content/posts/*.md`, extracts slugs from filenames, and writes `lib/generated/post_routes.dart` — a `const List<String> postSlugs = [...]`. This file is imported into `app.dart` to generate one `Route` per post. Run via `dart run tool/generate_routes.dart` before `jaspr build`.

> **Critical**: Jaspr static mode pre-renders every route listed in the Router at build time. Routes cannot be discovered at runtime. The `postSlugs` list must be populated before `jaspr build` runs.

### Data Sources

| Data | File | Type |
|---|---|---|
| Projects showcase | `lib/data/projects.dart` | Dart `const List<Project>` |
| Skills | `lib/data/skills.dart` | Dart `const List<Skill>` |
| Blog posts | `content/posts/*.md` | Markdown with YAML frontmatter |
| Generated slugs | `lib/generated/post_routes.dart` | Codegen output |

### SEO Strategy

- Global defaults: set in `Document(title:, meta:{...})` in `lib/main.server.dart`
- Per-page overrides: `Document.head(title:, meta:{...})` inside each page component
- Blog posts: per-post title, description, OG tags, and JSON-LD `BlogPosting` schema
- Homepage: JSON-LD `Person` schema in global Document head

---

## Implementation Tasks

### Phase 1 — Content Pipeline & Data Layer

- [ ] Create `content/posts/` directory with a sample post (`content/posts/2026-04-20-hello-world.md`)
- [ ] Add `front_matter: ^3.0.0` and `yaml: ^3.1.3` to `pubspec.yaml` (frontmatter parsing; `markdown` already present)
- [ ] Create `lib/models/post.dart` — `Post` and `PostMeta` data classes
- [ ] Create `tool/generate_routes.dart` — scans `content/posts/*.md`, emits `lib/generated/post_routes.dart`
- [ ] Create `lib/services/post_service.dart` — loads and parses all markdown posts at server startup; exposes `List<Post> loadAllPosts()`
- [ ] Create `lib/data/projects.dart` — `const List<Project>` with sample data
- [ ] Create `lib/data/skills.dart` — `const List<Skill>` with sample data
- [ ] Create `lib/data/models/project.dart` and `lib/data/models/skill.dart`

**Sample `content/posts/2026-04-20-hello-world.md`:**
```markdown
---
title: "Hello World"
date: "2026-04-20"
description: "Welcome to my new portfolio site and blog, built with Jaspr and Dart."
tags: ["Dart", "Jaspr", "Meta"]
---

# Hello World

Welcome to my new site! This is built with [Jaspr](https://jaspr.site), a Dart web framework.
```

**`lib/models/post.dart`:**
```dart
class PostMeta {
  final String title;
  final DateTime date;
  final String description;
  final List<String> tags;
  final String slug;
  // ...
}

class Post {
  final PostMeta meta;
  final String htmlContent;
  final int readingTimeMinutes; // ceil(wordCount / 200)
}
```

**`lib/generated/post_routes.dart` (generated):**
```dart
// GENERATED — do not edit by hand. Run: dart run tool/generate_routes.dart
const List<String> postSlugs = [
  'hello-world',
  'building-with-jaspr',
];
```

---

### Phase 2 — Router & Navigation Updates

- [ ] Update `lib/app.dart`:
  - Remove `/about` route
  - Add `/blog` route
  - Add one `Route` per `postSlug` in `postSlugs` at build time
  - Pass loaded posts to `Home`, `BlogListPage`, and `BlogPostPage` via constructor
- [ ] Update `lib/components/header.dart`:
  - Replace `About` nav link with `Blog`
  - Fix active state to match prefix: any path starting with `/blog` highlights Blog
  - Add `aria-current="page"` attribute to the active nav item

**Updated `app.dart` router (sketch):**
```dart
import 'generated/post_routes.dart';
import 'services/post_service.dart';

final posts = loadAllPosts(); // runs on server only during pre-render

Router(routes: [
  Route(path: '/', builder: (context, state) => Home(posts: posts.take(3).toList())),
  Route(path: '/blog', builder: (context, state) => BlogListPage(posts: posts)),
  for (final slug in postSlugs)
    Route(
      path: '/blog/$slug',
      builder: (context, state) => BlogPostPage(
        post: posts.firstWhere((p) => p.meta.slug == slug),
      ),
    ),
])
```

---

### Phase 3 — Portfolio Homepage

- [ ] Rewrite `lib/pages/home.dart` — compose five sections:
  - `HeroSection` (name, tagline, CTA button → `/#projects` hash scroll)
  - `AboutSection` (bio paragraph, photo)
  - `ProjectsSection` (grid of `ProjectCard` components, `id="projects"`)
  - `SkillsSection` (grouped skill tags)
  - `SocialsSection` (icon links to GitHub, LinkedIn, Twitter/X, Email)
- [ ] Create `lib/components/project_card.dart`
- [ ] Create `lib/components/socials_section.dart` — define `SocialLink` data (platform name, URL, SVG icon)
- [ ] Add per-page SEO in `HomeState` / `Home.build`:
  ```dart
  Document.head(
    title: 'Your Name — Software Engineer',
    meta: {
      'description': 'Personal portfolio and blog of Your Name...',
      'og:title': 'Your Name — Software Engineer',
      'og:type': 'website',
    },
  )
  ```
- [ ] Add JSON-LD `Person` schema to global `Document` head in `main.server.dart`

**`lib/pages/home.dart` structure:**
```dart
// lib/pages/home.dart
// lib/components/hero_section.dart
// lib/components/about_section.dart
// lib/components/projects_section.dart
// lib/components/skills_section.dart
// lib/components/project_card.dart
// lib/components/socials_section.dart
```

---

### Phase 4 — Blog Pages

- [ ] Create `lib/pages/blog/blog_list.dart` — `BlogListPage` component
  - List all posts sorted date-descending
  - Per post: title (linked), date, reading time, description, tag labels
  - Empty state: "No posts yet — check back soon."
- [ ] Create `lib/pages/blog/blog_post.dart` — `BlogPostPage` component
  - Render `post.htmlContent` using Jaspr's `RawText`
  - Byline: date + reading time
  - Tag labels
  - "← Back to Blog" link
  - Per-post SEO: `Document.head(title:, meta:{...})`
  - JSON-LD `BlogPosting` schema
- [ ] Add `highlight.js` CSS/script to `web/index.html` for code block syntax highlighting

**Blog post page SEO (in `blog_post.dart`):**
```dart
Document.head(
  title: '${post.meta.title} | Your Name',
  meta: {
    'description': post.meta.description,
    'og:title': post.meta.title,
    'og:description': post.meta.description,
    'og:type': 'article',
    'og:url': 'https://yoursite.com/blog/${post.meta.slug}',
    'twitter:card': 'summary_large_image',
  },
  children: [
    link(rel: 'canonical', href: 'https://yoursite.com/blog/${post.meta.slug}'),
    script(
      attributes: {'type': 'application/ld+json'},
      [RawText(jsonEncode({
        '@context': 'https://schema.org',
        '@type': 'BlogPosting',
        'headline': post.meta.title,
        'description': post.meta.description,
        'datePublished': post.meta.date.toIso8601String(),
        'author': {'@type': 'Person', 'name': 'Your Name'},
        'url': 'https://yoursite.com/blog/${post.meta.slug}',
      }))],
    ),
  ],
)
```

---

### Phase 5 — Global Polish

- [ ] Update `lib/constants/theme.dart` — add typography scale, spacing tokens
- [ ] Add responsive CSS breakpoints (mobile-first) in `app.dart` or a new `lib/constants/breakpoints.dart`
- [ ] Update `lib/main.server.dart`:
  - Change `title: 'blog'` to `title: 'Your Name'`
  - Add global meta defaults (`og:image`, `twitter:site`)
  - Add `Person` JSON-LD schema
- [ ] Create `web/404.html` — branded 404 page with link back to `/`
- [ ] Update `web/manifest.json` — replace placeholder `name`, `short_name`, `theme_color`
- [ ] Update `README.md`

---

## File Change Summary

### New files
```
content/
  posts/
    2026-04-20-hello-world.md
tool/
  generate_routes.dart
lib/
  models/
    post.dart
    project.dart
    skill.dart
  services/
    post_service.dart
  data/
    projects.dart
    skills.dart
  generated/
    post_routes.dart          ← codegen output
  pages/
    blog/
      blog_list.dart
      blog_post.dart
  components/
    hero_section.dart
    about_section.dart
    projects_section.dart
    skills_section.dart
    project_card.dart
    socials_section.dart
web/
  404.html
```

### Modified files
```
pubspec.yaml                  ← add front_matter, yaml
lib/app.dart                  ← update router
lib/components/header.dart    ← replace About with Blog, fix active state, aria-current
lib/pages/home.dart           ← full portfolio home rewrite
lib/main.server.dart          ← global title/meta/JSON-LD, per-page head injection
lib/constants/theme.dart      ← typography + spacing tokens
web/manifest.json             ← update name/short_name/theme_color
```

### Deleted files
```
lib/pages/about.dart          ← content moved to about_section.dart on homepage
```

---

## Acceptance Criteria

- [ ] `/` renders Hero, About, Projects, Skills, and Socials sections; CTA scrolls to `#projects`
- [ ] Socials section displays icon links for GitHub, LinkedIn, Twitter/X, and email
- [ ] `/blog` lists all posts sorted newest-first; shows title, date, reading time, description, tags
- [ ] `/blog` displays "No posts yet — check back soon." when `content/posts/` is empty
- [ ] `/blog/:slug` renders the correct post with full markdown content
- [ ] `/blog/:slug` shows byline (date + reading time), tags, and "← Back to Blog" link
- [ ] All pages have unique `<title>` and `<meta name="description">` tags
- [ ] Blog post pages have Open Graph and JSON-LD `BlogPosting` schema
- [ ] Homepage has JSON-LD `Person` schema
- [ ] Nav header shows Home and Blog; active state highlights the current section
- [ ] Blog nav item is highlighted for both `/blog` and `/blog/:slug`
- [ ] `aria-current="page"` is set on the active nav item
- [ ] Adding a new `.md` file to `content/posts/`, re-running `dart run tool/generate_routes.dart`, and rebuilding produces a new static post page
- [ ] Code blocks in posts are syntax-highlighted via highlight.js
- [ ] `web/404.html` exists with site branding and a home link
- [ ] Site is responsive (readable on 375px+ viewports)
- [ ] `jaspr build` produces a complete, deployable static site

---

## Testing Notes

- **Build pipeline test**: Create one post → run codegen → run `jaspr build` → verify the post appears at `/blog/the-slug` in the build output
- **Empty state test**: Remove all posts → run codegen → verify `/blog` shows the empty state message
- **Frontmatter validation**: Create a post with missing `title` field → verify the build fails gracefully or uses a sensible default, not a runtime error
- **SEO audit**: After build, open the HTML of `/`, `/blog`, and a post page — verify unique `<title>` and `<meta description>` in each file
- **Responsive**: Test at 375px (iPhone SE), 768px (tablet), 1280px (desktop)

---

## Dependencies to Add

```yaml
# pubspec.yaml additions
dependencies:
  front_matter: ^3.0.0   # YAML frontmatter parsing
  yaml: ^3.1.3           # YAML deserialization
```

> `markdown: ^7.3.1` is already present. `jaspr_content` is **not** used — the manual pipeline gives full layout control without replacing the App component structure.

---

## References

- [Jaspr Static Sites](https://docs.jaspr.site/dev/static_sites)
- [jaspr_router docs](https://pub.dev/packages/jaspr_router)
- [markdown package](https://pub.dev/packages/markdown)
- [front_matter package](https://pub.dev/packages/front_matter)
- [yaml package](https://pub.dev/packages/yaml)
- [highlight.js](https://highlightjs.org/)
