# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal portfolio and blog site for Andy Horn, built with **Jaspr** (a Dart web framework) in **static** mode with **embedded Flutter**. The site pre-renders to static HTML at build time; Flutter is embedded for interactive widgets only.

## Commands

```bash
# Development server (localhost:8080)
jaspr serve

# Production build (output: build/jaspr/)
jaspr build

# Regenerate post routes after adding/removing blog posts
dart run tool/generate_routes.dart

# List blog post images (cover or inline) that have a prompt but no file yet
dart run tool/find_posts_without_images.dart

# Generate one image from a prompt and save it to a path
dart run tool/generate_image.dart --prompt "..." --output web/images/posts/foo.png [--ratio 16:9]

# Generate every missing post image and update frontmatter / inline tags
source bin/get-gemini-api-key.sh && dart run tool/generate_post_images.dart
```

> **Gemini API key**: `bin/get-gemini-api-key.sh` retrieves the key from 1Password and exports it as `GEMINI_API_KEY`. Always `source` this script before running any `tool/generate_*.dart` script — never hardcode or prompt for the key manually.

## Architecture

### Dual Entrypoints

Jaspr uses two separate entry points:

- `lib/main.server.dart` — runs **server-side only** during pre-rendering. Sets up the `Document` (title, meta, head tags, JSON-LD schema, font imports). Do not put client-only code here.
- `lib/main.client.dart` — runs **client-side only** in the browser. Uses `ClientApp` to hydrate `@client`-annotated components.

### App Structure

`lib/app.dart` is the root component. It loads all blog posts via `loadAllPosts()` (server-side only) and sets up `jaspr_router` routes. Blog post routes are driven by the generated slug list in `lib/generated/post_routes.dart`.

### Blog System

- Blog posts live in `content/posts/` as Markdown files named `YYYY-MM-DD-slug.md` with YAML frontmatter (`title`, `date`, `description`, `tags`).
- `lib/services/post_service.dart` reads and parses these files at build time (server-side only, using `dart:io`).
- `lib/generated/post_routes.dart` is a **generated file** — run `dart run tool/generate_routes.dart` whenever you add or remove a post. Never edit it by hand.
- Markdown is rendered to HTML using the `markdown` package with GitHub Web extension set.

### Pages

- `lib/pages/home.dart` — the single-page portfolio layout, composed of section components
- `lib/pages/blog/blog_list.dart` and `blog_post.dart` — blog listing and individual post pages
- `lib/pages/about.dart` — standalone about page

### Components

`lib/components/` contains section components for the home page (Hero, Bridge, Stats, About, Apps, Packages, BlogPreview, Contact) plus shared components (Header, SiteFooter). Each component owns its own CSS via the `@css` annotation.

### Data & Models

Static data for the portfolio sections lives in `lib/data/` (apps, packages, skills, projects). Model classes are in `lib/models/`.

### Styling System

- Design tokens are centralized in `lib/constants/theme.dart` — all colors, font sizes, spacing, and breakpoints as Dart constants.
- Styles are written in Dart using Jaspr's CSS DSL with `@css`-annotated static getters. Styles are scoped to their component's CSS class hierarchy.
- The global base styles (`html`, `body`, `a`, `.container`) are in `lib/constants/theme.dart`.
- Dark theme: background `#0A0A0A`, accent purple `#A855F7`, typography using Geist/Inter fonts.

### Flutter Embedding

The `lib/widgets/` and `lib/components/embedded_counter.dart` demonstrate the Flutter embedding pattern. Interactive Flutter widgets are annotated with `@client` and hydrated in the browser. The `jaspr` config in `pubspec.yaml` sets `flutter: embedded`.

## Git Conventions

Always use [Conventional Commits](https://www.conventionalcommits.org/) prefixes for commit messages and PR titles:

- `feat:` — new feature
- `fix:` — bug fix
- `refactor:` — code change that neither fixes a bug nor adds a feature
- `style:` — formatting, whitespace, CSS-only changes
- `docs:` — documentation changes
- `chore:` — build process, tooling, dependency updates
- `test:` — adding or updating tests

Examples: `feat: add mobile nav hamburger menu`, `fix: correct header z-index on scroll`

## Jaspr Reference

For Jaspr API questions, always fetch `https://jaspr.site/llms.txt` first rather than searching through framework source code. The available Jaspr skills (`jaspr-fundamentals`, `jaspr-styling`, `jaspr-pre-rendering-and-hydration`, `jaspr-convert-html`, `jaspr-js-interop`) cover the most common patterns and should be invoked before attempting to write Jaspr code from scratch.
