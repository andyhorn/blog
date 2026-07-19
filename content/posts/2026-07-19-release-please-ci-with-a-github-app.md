---
title: "Getting CI to Run on Your release-please PRs"
date: "2026-07-19"
description: "release-please opens a tidy release PR — but with the default GITHUB_TOKEN it runs no CI. Here's why, and how a custom GitHub App fixes it."
tags: ["github-actions", "ci-cd", "release-please", "devops", "automation"]
image_prompt: A tall pull-request checks panel floating on a deep blue-purple background. Its rows are dim and empty grey on the left, but a warm-glowing key slotting into a padlock at the panel's edge flips them one by one into softly glowing green checkmarks flowing to the right. Flat digital illustration, rounded shapes, no hard edges, cinematic lighting.
image:
---

# TL;DR

[release-please](https://github.com/googleapis/release-please) opens a release PR for you, but if the Action runs with the default `GITHUB_TOKEN`, that PR won't trigger your `on: pull_request` CI. GitHub blocks it on purpose — events raised by `GITHUB_TOKEN` can't kick off more workflow runs (it's how they stop infinite loops).

The fix is to open the PR with a different credential. Mint a short-lived token from a custom **GitHub App** and hand it to release-please:

```yaml
- uses: actions/create-github-app-token@v1
  id: app-token
  with:
    app-id: ${{ secrets.RELEASE_PLEASE_APP_ID }}
    private-key: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}

- uses: googleapis/release-please-action@v4
  with:
    token: ${{ steps.app-token.outputs.token }}
```

That's the whole trick. The rest of this post is the *why* and the setup.

----

## What release-please actually does

If you haven't used it: [release-please](https://github.com/googleapis/release-please) is Google's release automation. It reads your [Conventional Commits](https://www.conventionalcommits.org/) — the same `feat:` / `fix:` / `chore:` prefixes I already use on this blog — and keeps an open "release PR" that bumps your version and updates your changelog based on what's landed on `main` since the last release. When you're ready to ship, you merge that PR, and release-please tags the release and (optionally) publishes it.

It's a lovely workflow: your changelog writes itself, and cutting a release is one click. Except for one very annoying wrinkle.

## :ghost: The release PR with no checks

The first time I wired it up, release-please did exactly what it promised — a clean release PR appeared, changelog and version bump and all.

And then it just... sat there.

No checks. The bottom of the PR, where my build-and-test workflow normally reports in, was empty. Not failing — *absent*, as if the CI workflow didn't exist. Every other PR on the repo ran the full suite. This one, the one literally cutting a release, ran nothing.

That's the worst possible PR to skip CI on. And if you've got branch protection with required status checks (you should), it's even better: the release PR can *never* satisfy them, so it can never merge. The automation designed to make releases effortless had made them impossible.

## :bulb: Why it happens

This isn't a release-please bug. It's a deliberate GitHub rule, and once you know it you'll spot it everywhere.

By default, the `release-please-action` authenticates with the automatic `GITHUB_TOKEN` that every workflow run gets. But GitHub has a standing rule about that token:

> When you use the repository's `GITHUB_TOKEN` to perform tasks, events triggered by the `GITHUB_TOKEN`... will not create a new workflow run.

— [GitHub Actions docs](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#using-the-github_token-in-a-workflow)

So the release PR *is* opened — but because `GITHUB_TOKEN` opened it, the `pull_request` event that would normally fire my CI is silently suppressed. It's an intentional guardrail against runaway recursion (imagine a workflow that opens a PR, whose CI opens another PR, forever). Useful rule. Just really inconvenient here.

The way out is simple once you see it: **open the PR with a credential that isn't `GITHUB_TOKEN`.** Then it's an ordinary PR from GitHub's perspective, and CI runs like it does for everything else.

## :closed_lock_with_key: Why a GitHub App (and not just a PAT)

You've got two options for that "other credential."

The quick one is a **Personal Access Token**. It works — a fine-grained PAT with contents and pull-request write access will do the job. But it's tied to *me*: it acts as my account, it counts against my rate limits, and if I ever leave the org or rotate the token, the automation breaks. For something that runs unattended forever, tying it to a human is a smell.

A **GitHub App** is the better fit:

- It's its own identity — the release PR shows up as authored by your app (e.g. `my-release-bot[bot]`), not a person.
- The token it mints is **installation-scoped and short-lived** — it's created at the start of the job and expires when the job ends. Nothing long-lived sits in your secrets acting as you.
- You grant it *only* the permissions release-please needs, on *only* the repos you install it on.
- It gets its own, healthier API rate limit and doesn't consume a seat.

So that's the route I took.

## :wrench: Setting it up

**1. Create the App.** Go to **Settings → Developer settings → GitHub Apps → New GitHub App** (under your personal account or your org). Give it a name, set any homepage URL (it doesn't matter), and **uncheck "Active" under Webhook** — this app never receives events, it only acts.

**2. Give it permissions.** Under **Repository permissions**, set:

- **Contents:** Read and write — to push the version bump and changelog.
- **Pull requests:** Read and write — to open and update the release PR.

If you use release-please's labels (it adds `autorelease: pending` and friends), also grant **Issues: Read and write**. Save.

**3. Generate a private key.** On the App's settings page, scroll to **Private keys** and click **Generate a private key**. A `.pem` file downloads — you'll paste its full contents into a secret in a moment.

**4. Install it.** From the App's page, hit **Install App** and install it on the repo (or repos) you want it to manage. *This step is easy to forget and nothing works without it* — creating an App doesn't automatically give it access to anything.

**5. Store the credentials as repo secrets.** In the target repo, under **Settings → Secrets and variables → Actions**, add:

- `RELEASE_PLEASE_APP_ID` — the numeric **App ID** from the App's settings page.
- `RELEASE_PLEASE_APP_PRIVATE_KEY` — the entire contents of that `.pem` file, `-----BEGIN...` line and all.

**6. Wire up the workflow.** Here's the whole thing, `.github/workflows/release-please.yml`:

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
      - uses: actions/create-github-app-token@v1
        id: app-token
        with:
          app-id: ${{ secrets.RELEASE_PLEASE_APP_ID }}
          private-key: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}

      - uses: googleapis/release-please-action@v4
        with:
          token: ${{ steps.app-token.outputs.token }}
```

The [`actions/create-github-app-token`](https://github.com/actions/create-github-app-token) step exchanges your App ID and private key for a fresh installation token and exposes it as `steps.app-token.outputs.token`. The only line that actually matters for our problem is the last one:

```yaml
    token: ${{ steps.app-token.outputs.token }}
```

That single override is the difference between a release PR that runs CI and one that doesn't. Everything else is release-please's normal configuration.

## :white_check_mark: The payoff

Push a `feat:` or `fix:` to `main`, and release-please opens the release PR — this time authored by the App. And because the App isn't `GITHUB_TOKEN`, GitHub treats it as a real `pull_request` event: my build-and-test workflow fires, the checks show up at the bottom of the PR, and they go green.

Now required status checks pass, the merge button lights up, and I get what I wanted all along — a release I can actually *verify* before I ship it, cut with a single click.

## :pushpin: A few gotchas

- **Install the App, don't just create it.** By far the most common "why isn't this working" — the App exists but was never installed on the repo, so the token has access to nothing.
- **Match the permissions.** If release-please tries to do something the App can't (write a label without Issues access, say), the job fails with a permissions error. Grant what it needs, no more.
- **The token is short-lived by design.** The installation token expires when the job finishes. That's a feature, not something to work around — there's no long-lived credential sitting in your secrets pretending to be you.
- **This is orthogonal to release-please's own config.** Manifest mode, a `release-please-config.json`, monorepo setups — none of that changes the token wiring. The App token goes in the same `token:` input regardless.
