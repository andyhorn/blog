---
name: new-draft-post
description: Create a new draft blog post — branch, file, and frontmatter template — from a title.
---

The user wants to create a new draft blog post. Follow every step below in order.

## Step 1 — Collect the title

If the user provided a title in their message, use it. Otherwise, ask for it with AskUserQuestion before proceeding.

## Step 2 — Derive the slug

Slugify the title:
- Lowercase everything
- Replace spaces and any non-alphanumeric characters (except hyphens) with hyphens
- Collapse consecutive hyphens into one
- Strip leading/trailing hyphens

Example: `"Debugging Swift & Firebase: A Bug Story"` → `debugging-swift-firebase-a-bug-story`

## Step 3 — Create the branch

Run:
```bash
git checkout -b drafts/{slug}
```

The branch must be named `drafts/{slug}` exactly.

## Step 4 — Create the post file

The filename format is `YYYY-MM-DD-{slug}.md` using today's date (available in the system context as `currentDate`).

Path: `content/posts/YYYY-MM-DD-{slug}.md`

Write the file with this frontmatter template, filling in what you can:

```markdown
---
title: "{Original Title}"
date: "YYYY-MM-DD"
description: ""
tags: []
image_prompt: 
image: 
---


```

- `title`: the original title as provided by the user (preserve capitalisation)
- `date`: today's date in `YYYY-MM-DD` format
- `description`, `tags`, `image_prompt`, `image`: leave blank — the user will fill these in

## Step 5 — Regenerate routes

Run:
```bash
dart run tool/generate_routes.dart
```

This updates `lib/generated/post_routes.dart` so the new post is included in the build.

## Step 6 — Report back

Tell the user:
- The branch name
- The file path created
- Which frontmatter fields still need to be filled in (`description`, `tags`, `image_prompt`, `image`)
