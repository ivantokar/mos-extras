# Molecules of Swift #3 — Isolated Deinitialization

Companion Playground for the article:

**@MainActor Doesn’t Own Your Lifetime**

## What this verifies

- a globally isolated class can declare `isolated deinit`;
- actor-isolated state can be accessed during an isolated deinitializer;
- ownership and actor isolation are separate concerns;
- the last strong reference can be released from code running outside the actor;
- explicit lifecycle methods remain useful when cleanup timing is part of the API contract.

## Running

Open `IsolatedDeinit.playground` in Xcode with a Swift 6.2+ toolchain and run the Playground.

Because executor scheduling and ARC release location are runtime concerns, printed ordering is observational evidence rather than a language guarantee about threads.

## Manual compiler experiments

The source contains commented variants for comparing an ordinary `deinit` with `isolated deinit`. Enable them individually and inspect Swift concurrency diagnostics with strict concurrency checking enabled.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
