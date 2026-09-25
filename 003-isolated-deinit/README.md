# Molecules of Swift #3 — Isolated Deinitialization

Companion Playground for the article:

**@MainActor Doesn’t Own Your Lifetime**

## What this verifies

- a globally isolated class can declare `isolated deinit`;
- `MainActor.preconditionIsolated()` succeeds inside a MainActor-isolated deinitializer;
- ARC still controls when the final strong reference disappears;
- the final release can happen in detached work while isolated destruction runs under MainActor isolation;
- explicit cleanup gives the caller a deterministic completion point;
- asynchronous follow-up work can capture copied values instead of `self`;
- an ordinary synchronous `deinit` is nonisolated by default and cannot freely access non-Sendable actor-isolated state in Swift 6 mode.

## Running

Open `IsolatedDeinit.playground` in Xcode with a Swift 6.2+ toolchain and run the Playground.

The runtime examples use `MainActor.preconditionIsolated()` to verify actor isolation directly. Printed ordering should not be treated as a general guarantee about threads or scheduling.

## Manual compiler experiments

The final sections compare a plain `deinit` with `isolated deinit` when a MainActor-isolated class owns non-Sendable state.

Enable those examples individually with Swift 6 language mode and strict concurrency checking to inspect the diagnostics.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
