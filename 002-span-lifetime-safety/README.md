# Molecules of Swift #2 — Span Lifetime Safety

Companion Playground for the article:

**Span: Lifetime Safety Without the Closure**

## What this verifies

- `Span` provides a non-owning view over contiguous storage;
- an Array can expose a `Span` without manually handling an unsafe pointer;
- functions can consume a `Span` directly and access its elements by index;
- a `Span` is lifetime-dependent and is not an ordinary owning collection value;
- owned data can be copied explicitly when independent ownership is required;
- unsafe pointer APIs remain available when explicit pointer interoperability is required.

## Running

Open `SpanLifetime.playground` in Xcode with a Swift 6.2+ toolchain and run the Playground.

## Manual compiler experiments

The source contains commented lifetime experiments. Uncomment them individually to inspect diagnostics for storing or returning a lifetime-dependent `Span` where its dependency cannot be preserved.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
