# Molecules of Swift #2 — Span Lifetime Safety

Companion Playground for the article:

**Span: Lifetime Safety Without the Closure**

## What this verifies

- `Span` provides a non-owning view over contiguous storage;
- an Array can expose a `Span` without manually handling an unsafe pointer;
- functions can consume a `Span` directly and iterate its elements;
- the source collection remains the owner of the storage;
- `Span` is useful for borrowed access, not ownership transfer;
- unsafe pointer APIs still remain available when explicit pointer interoperability is required.

## Running

Open `SpanLifetime.playground` in Xcode with a Swift 6.2+ toolchain and run the Playground.

## Manual compiler experiments

The source contains commented lifetime experiments. Uncomment them individually to inspect the compiler diagnostics produced when a borrowed `Span` is made to escape its valid lifetime.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
