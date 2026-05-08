---
title: "The Firebase Crash That Wasn't a Firebase Bug"
subtitle: "How a Swift 6.1 compiler regression made me waste an afternoon blaming the wrong thing"
date: 2026-04-24
tags: [flutter, firebase, ios, debugging, swift]
image_prompt: Several translucent panes of glass stacked in receding depth on a deep blue-purple background. The front pane is shattered and glowing warm orange, dramatic and eye-catching. But the crack pattern clearly originates from a single small impact point on the rearmost pane, pulsing faint cyan — the real source, almost invisible behind the noise in front. Flat digital illustration, rounded shapes, no hard edges, cinematic lighting.
image: "/images/posts/swift-firebase-bug.png"
---

# TL;DR

Error `asyncLet_finish_after_task_completion` is due to a regression in the Swift 6.1 compiler ([swiftlang/swift#81771](https://github.com/swiftlang/swift/issues/81771)), which ships with Xcode 16.3 and later. Any execution of `async let` inside a `try/catch` block will fail.

For me, the workaround was pinning `FirebaseFunctions` to `v12.4.0` (pre-Swift 6.1).

In `ios/Podfile`:

```ruby
pod 'FirebaseFunctions', '~> 12.4.0'
```

As of the writing of this post, the issue [#81771](https://github.com/swiftlang/swift/issues/81771) is still open on GitHub.

----

After a recent update for macOS and Xcode, I was working on a Flutter app that had been running without issue. But today, it was crashing anytime I tried calling a Firebase cloud function. And it wasn't just crashing; the app died with no logs or anything.

## :ghost: Chasing a Ghost

Obviously, I suspected that Firebase or [`cloud_functions`](https://pub.dev/packages/cloud_functions) was the culprit. I cleaned and re-installed, verified the cloud function was deployed and responding, and began stepping through the code. I asked Claude for help debugging and we pursued the Firebase issue for hours.

I could trace the issue down to the functions call, but could not, for the life of me, get a breakpoint to stick. Finally giving up on breakpoints and `debugPrint` statements in the code, I pulled up Xcode to view the device logs.

```
Thread 34 Crashed::  Dispatch queue: com.apple.root.user-initiated-qos.cooperative
0   libswift_Concurrency.dylib    swift::swift_Concurrency_fatalErrorv
...
6   libswift_Concurrency.dylib    swift::_swift_task_dealloc_specific
7   libswift_Concurrency.dylib    asyncLet_finish_after_task_completion
8   FirebaseFunctions             HTTPSCallable.call(_:)  (HTTPSCallable.swift:163)
9   FirebaseFunctions             closure #1 in HTTPSCallable.call(_:completion:)  (HTTPSCallable.swift:123)
```

To my tired brain, this just confirmed that the problem was, indeed, a Firebase issue. But this was the iOS plugin; I had no idea what to do.


## :bulb: The breakthrough

Exhausted and defeated, I started trying out different workflows. Half investigating, half poking around and grumbling to myself, and... wait, `image_picker` is **also** triggering the crash? 

That was our breakthrough. Claude immediately began searching the Swift issue tracker and quickly surfaced [swiftlang/swift#81771](https://github.com/swiftlang/swift/issues/81771): a regression in the Swift 6.1 compiler.

It matched my symptoms exactly!

I don't know how long it would have taken me to figure that out, if ever. I don't know enough about the Swift/Xcode-side of Flutter to even know what to look for.

## :wrench: The Fix

Soon, I had a proposed resolution: pin `FirebaseFunctions` (or whatever is using the `try { async let ...} catch {...}` pattern) to a version before Swift 6.1. For my case: `12.4.0`.

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

## :pushpin: Status as of April 2026

[Issue #81771](https://github.com/swiftlang/swift/issues/81771) is still open. A fix PR surfaced on the Swift forums in late February 2026, but as of this writing it hasn't shipped in a stable Xcode release. If you're reading this from the future and Xcode 16.5+ is out, try updating Xcode first - the compiler fix may finally be in, and you won't need the pod pin at all.