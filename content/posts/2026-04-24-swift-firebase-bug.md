---
title: "The Firebase Crash That Wasn't a Firebase Bug"
subtitle: "How a Swift 6.1 compiler regression made me waste an afternoon blaming the wrong thing"
date: 2026-04-24
tags: [flutter, firebase, ios, debugging, swift]
---

I updated Xcode. Then my Flutter app started crashing every time it called a Cloud Function. No Dart exception. No `try/catch` catching anything. No logs in Firebase. Just — the app dies.

If you're here because you Googled `swift_task_dealloc asyncLet_finish_after_task_completion HTTPSCallable`, skip to the bottom. The fix is a one-liner in your `Podfile`. But the story is worth telling, because the bug that got me here isn't actually a Firebase bug at all, and I spent way too long before I figured that out.

## The crash

Here's the stack trace that kept showing up:

```
Thread 34 Crashed::  Dispatch queue: com.apple.root.user-initiated-qos.cooperative
0   libswift_Concurrency.dylib    swift::swift_Concurrency_fatalErrorv
...
6   libswift_Concurrency.dylib    swift::_swift_task_dealloc_specific
7   libswift_Concurrency.dylib    asyncLet_finish_after_task_completion
8   FirebaseFunctions             HTTPSCallable.call(_:)  (HTTPSCallable.swift:163)
9   FirebaseFunctions             closure #1 in HTTPSCallable.call(_:completion:)  (HTTPSCallable.swift:123)
```

The crash is on a cooperative thread pool queue — that's the Swift concurrency executor. `swift_task_dealloc` is aborting because it's trying to free task-local memory in the `async let` cleanup path, and something about that cleanup is going sideways.

The frames pointing at `FirebaseFunctions/HTTPSCallable.swift` made the culprit look obvious. Firebase SDK bug. Case closed. Right?

Right???

## Chasing the wrong ghost

My Dart code was the standard pattern:

```dart
final callable = FirebaseFunctions.instance
    .httpsCallable('estimateRecipeNutrition');
final result = await callable.call({ /* payload */ });
```

Nothing weird. Nothing fire-and-forget. Proper `await`. The function was deployed — I could see it in `firebase functions:list`. The region was correct. No emulator config lingering around. I was on `cloud_functions: ^6.1.0`, which pulls in FirebaseFunctions 12.9.0 on the iOS side.

So I went down the obvious path: this must be a `cloud_functions` 6.1.0 + FirebaseFunctions 12.9.0 incompatibility. I started looking at issue trackers, checking for patch releases, mentally preparing to pin a plugin version and move on.

Then I tried to open the image picker in a totally unrelated part of the app. Same crash. `swift_task_dealloc`. `asyncLet_finish_after_task_completion`. Different plugin, identical death.

That was the moment the Firebase theory died.

## The pivot

When two unrelated plugins die the same way, you don't have two plugin bugs. You have a system-level problem that *both* plugins happen to trip over.

Both FirebaseFunctions and the image picker plugin use Swift Concurrency under the hood. The crash is in `libswift_Concurrency.dylib`, which is the runtime library. And I had just updated Xcode.

Plug those together and the shape of the real bug becomes visible: something about the newer Swift concurrency runtime is breaking on a pattern these plugins use.

At this point I also surfaced a completely unrelated red herring — I was missing a Google Sign-In URL scheme in my `Info.plist`:

```
PlatformException(google_sign_in, Your app is missing support for the following URL schemes: com.googleusercontent.apps.193621401025-...)
```

Real issue. Real fix needed. But not *this* issue. I mention it only because it's exactly the kind of thing that'll sidetrack you mid-debug — you'll find a plausible error, fix it, retest, crash again, and feel like you're losing your mind. Fix red herrings, but don't assume they were the thing.

## The actual bug

It turns out this is a known Swift compiler regression: [swiftlang/swift#81771](https://github.com/swiftlang/swift/issues/81771). In Swift 6.1 — which ships with Xcode 16.3 and later — any `async let` binding inside a `do {}` block causes a runtime crash in `swift_task_dealloc` during async task cleanup. It's the compiler, not Firebase.

And wouldn't you know it, `FirebaseFunctions.HTTPSCallable.call()` uses exactly that pattern internally. So does the image picker plugin. So does probably half the Swift code on your machine — you just haven't called it yet. Before Xcode 16.3, everything worked. After, anything hitting that code path blows up.

There's already a PR open to fix the compiler bug, but it hasn't landed yet. Which leaves you with a few options, none of them thrilling:

1. **Downgrade Xcode to 16.2.** Nuclear, but it works.
2. **Pin `FirebaseFunctions` to a version that doesn't hit the broken pattern.** This is what I did.
3. **Wait for the Swift fix to ship.** Cool, great, not helpful today.

## The fix

In `ios/Podfile`:

```ruby
pod 'FirebaseFunctions', '~> 12.4.0'
```

Then:

```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter clean
flutter run
```

12.4.0 predates the internal rewrite that introduced the `async let` pattern triggering the compiler bug. Your Cloud Functions calls will work again. So will anything else in your app that was caught in the blast radius — in my case, the image picker started behaving the moment I rebuilt, even though I hadn't touched it, because the runtime was no longer being poisoned by a separate crash path earlier in the session.

## Status as of April 2026

[Issue #81771](https://github.com/swiftlang/swift/issues/81771) is still open. A fix PR surfaced on the Swift forums in late February 2026, but as of this writing it hasn't shipped in a stable Xcode release. If you're reading this from the future and Xcode 16.5+ is out, try updating Xcode first — the compiler fix may finally be in, and you won't need the pod pin at all.

## The lesson

The thing I want to remember from this, and the reason I'm writing it down: **when two unrelated plugins break the same way, stop blaming the plugins.** The shared code isn't yours and isn't theirs — it's the runtime beneath both of them. Look down, not sideways.

Also: always check what you just updated. I knew I'd updated Xcode. I knew the crash started right after. I still spent an hour poking at Firebase SDK versions before I took that seriously. Recency is a signal. Use it.

If you landed here from Google and this saved you the afternoon I lost, you're welcome. Go pin the pod.