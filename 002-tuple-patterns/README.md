# Molecules of Swift #002 — Tuple Patterns: Destructure Values Where You Use Them

Companion Playground for **Tuple Patterns: Destructure Values Where You Use Them**.

## What this verifies

- A tuple can be decomposed into local bindings with a matching pattern.
- `_` ignores a tuple position without creating a binding.
- `for-in` can destructure tuple elements directly.
- Tuple patterns in `switch` can combine literals, ranges, wildcards, and value bindings.
- A `where` clause can refine a matched tuple after its values are bound.
- `if case` uses the same pattern language.
- Pattern shape must match the value being destructured.

## Running

Open `TuplePatterns.playground` in Xcode and run it from top to bottom.

Section 8 contains an inactive compiler experiment. Uncomment it to inspect the type-checker diagnostic.

## Article

Read the article: [Tuple Patterns: Destructure Values Where You Use Them](https://ivantokar.com/posts/tuple-patterns-destructure-values-where-you-use-them)
