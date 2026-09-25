# Molecules of Swift #2 — Span Lifetime Safety

Companion Playground for the article:

**Span: Lifetime Safety Without the Closure**

## What this verifies

- `Array.span` exposes a borrowed `Span` without using an unsafe pointer API;
- functions can accept `Span` directly and read its elements;
- the source collection remains the owner of the storage;
- a local `Span` keeps a borrowing relationship to the source binding;
- once the borrow ends, the source can be mutated again;
- an owned copy is an explicit separate operation;
- unsafe pointer APIs remain available for pointer-oriented interoperability;
- mutating the source while a `Span` still borrows it produces an overlapping-access diagnostic;
- ordinary code cannot freely return or store a `~Escapable` `Span` without a valid lifetime relationship.

## Running

Open `SpanLifetime.playground` in Xcode with a Swift 6.2+ toolchain and run the Playground.

Runtime experiments print their results directly.

## Manual compiler experiments

The final sections are intentionally commented out. Enable them one at a time to inspect:

1. mutation while a `Span` still borrows an `Array`;
2. returning a `Span` from an ordinary function;
3. storing a lifetime-dependent `Span` at top level in a script/Playground context.

Keep those experiments inactive when you want the whole Playground to run.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
