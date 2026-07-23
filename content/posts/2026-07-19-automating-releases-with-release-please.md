---
title: "Automating Releases with release-please"
date: "2026-07-19"
description: "Stop hand-editing changelogs and bumping version numbers. Let your Conventional Commits drive a release PR that writes itself."
tags: ["github-actions", "ci-cd", "release-please", "devops", "automation"]
image_prompt: Hand-drawn ink and watercolor editorial illustration on a warm cream paper background, muted natural colors, loose expressive linework, visible paper grain, lots of negative space. A small brown cardboard parcel gift-wrapped with string and a tiny bow, seen at a gentle three-quarter angle, ready to ship, with a hand-lettered white shipping label on its front reading the semantic version "v1.4.0" above a small barcode. A few soft grey motion marks behind it suggest it was just set down. Painterly watercolor washes, no digital screens, no hard vector edges.
image: "/images/posts/automating-releases-with-release-please.png"
---

I was recently introduced to the [`release-please` GitHub Action](https://github.com/googleapis/release-please-action) and have since implemented it in every one of my projects. It automates all of my CHANGELOG updates, version bumping, and release tagging. My delivery pipeline watches for new version tags, so triggering a full build and release only requires merging a PR.

With the basic setup (see below), the `release-please` workflow runs on every push to `main`. It identifies the new commits and updates your CHANGELOG and bumps the version number based on the conventional commit prefixes since the last release.

## Conventional Commits

`release-please` uses the conventional commit prefixes in your git history to determine the next version.

| Prefix | Type | Version | New version |
| :--- | :--- | ---: | ---: |
| `fix:` | patch | 1.4.0 | 1.4.1 |
| `feat:` | minor | 1.4.0 | 1.5.0 |
| `feat!:` (or `BREAKING CHANGE` in the footer) | major | 1.4.0 | 2.0.0 |
| `chore`, `docs`, `refactor`, `test`, `perf`, `style` | none | 1.4.0 | N/A |

Read more about [Conventional Commits](https://www.conventionalcommits.org/).

## Workflow

The basic workflow is a single action.

```yaml
name: Release Please

on:
  push:
    branches: [main]

permissions:
  # needed to commit the CHANGELOG and version bump
  contents: write

  # needed to create and maintain the release PR
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        with:
          release-type: dart  # bumps the version in pubspec.yaml
```

The `release-type` tells `release-please` how your project is versioned — `dart` tracks the version in your `pubspec.yaml`. It also handles `node`, `python`, `rust`, `simple` (a plain `version.txt`), and more.

With this action in place, you'll see a release PR in your repo after your first conventional commit is pushed to main.

One caveat: your CI checks _will not_ automatically run on this PR. This is because GitHub does not run CI for changes pushed with the `secrets.GITHUB_TOKEN`, which `release-please` uses by default. Your CI checks will sit, indefinitely, waiting for a status.

It's a [deliberate choice by GitHub](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#using-the-github_token-in-a-workflow) to prevent recursive workflow runs — a useful rule, but it slows us down here.

## Getting CI to run on the release PR

The fix is to run `release-please` as a different _identity_. You've got two options: a Personal Access Token (PAT) or a GitHub App.

### Why use a GitHub App?

GitHub's examples use a PAT because it's quick and easy, but it comes with a few drawbacks:

  * Typical PATs grant access to _every_ repo that user can access
  * It's tied to **you** and your account. If you leave the org, disable your account, change your password, or reset your tokens, the PAT becomes invalid and the action will fail
  * Fine-grained PATs expire (max 1 year) and classic PATs _can_ expire, also leading to failure
  * PATs share your rate limits

A **GitHub App**, on the other hand, is its own identity - the release PR shows up as authored by the bot. The token it creates is finely-tuned with specific permissions for one repo and it's **short-lived** (created when the job starts, expires when it ends). Because it's a separate identity, it also has its own rate limits.

### Setup

A one-time, five-minute setup. Steps 1-4 happen in the GitHub App UI; step 5 is over in your repo.

1. **Create the App**
    1. Open **Settings** > **Developer settings** > **GitHub Apps** and click **New GitHub App**
    2. Give your app a name (`my-project-release-please`)
    3. Provide a **Homepage URL** (it can be anything, like the repo URL)
    4. Uncheck **Active** in the **Webhook** section
2. **Grant permissions**
    * **Contents: Read and write**
    * **Pull requests: Read and write**
    * **Issues: Read and write**
3. **Generate a private key**
    1. On the App's **General** page, scroll to the **Private keys** section near the bottom
    2. Click **Generate a private key**
    3. Download the key and keep it somewhere safe
4. **Install the App**
    1. Click **Install App** in the sidebar
    2. Choose **Only select repositories** and select your target repo
5. **Add the repo secrets**
    1. Open your repo settings (open the repository page and click the **Settings** tab)
    2. Click **Secrets and Variables** > **Actions**
    3. Create `RELEASE_PLEASE_APP_ID` with the App ID
    4. Create `RELEASE_PLEASE_APP_PRIVATE_KEY` with the contents of the `.pem` file you downloaded earlier

Finally, update your workflow to generate a temporary token using the `create-github-app-token` action:

```yaml
name: Release Please

on:
  push:
    branches: [main]

permissions:
  contents: write
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      # NEW
      # exchange the App ID and private key for a fresh token
      - uses: actions/create-github-app-token@v1
        id: app-token
        with:
          app-id: ${{ secrets.RELEASE_PLEASE_APP_ID }}
          private-key: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}

      - uses: googleapis/release-please-action@v4
        with:
          release-type: dart
          token: ${{ steps.app-token.outputs.token }}
```

The [`actions/create-github-app-token`](https://github.com/actions/create-github-app-token) step exchanges your App ID and private key for a fresh installation token.

## The payoff

That's the whole loop: commit with Conventional Commit prefixes, and
release-please keeps a release PR up to date with your next version, an
updated CHANGELOG, and — now that it runs as a GitHub App — a full set of
passing CI checks.

No more hand-editing changelogs, guessing the next version number, or
tagging releases from your terminal. Your commit messages already describe
what changed; this just handles the bookkeeping.

Releasing is now a simple code review: read the PR, merge it, and ship.
