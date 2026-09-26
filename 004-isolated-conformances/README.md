# Molecules of Swift #004 — Isolated Conformances

Companion Playground for **Isolated Conformances: Protocols Can Stay on the Actor**.

## What this verifies

- isolated protocol conformances can use actor-isolated state;
- generic code can use the conformance from the matching actor;
- `Sequence.contains` works with an isolated `Equatable` conformance on that actor;
- a conformance may be isolated even when the type itself is not;
- the compiler rejects use from the wrong isolation domain;
- `SendableMetatype` constraints do not accept isolated conformances.

## Running

Open `IsolatedConformances.playground` in Xcode and run it.

The active source was checked with Swift 6.2.1 in Swift 6 mode with complete strict concurrency. Commented manual experiments cover the compiler-error cases.

## Article

Part of the Molecules of Swift series. Article URL will be added after publication.
