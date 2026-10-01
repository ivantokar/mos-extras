# Molecules of Swift #002 — Tuple Patterns: Destructure Values Where You Use Them

Executable companion for **Tuple Patterns: Destructure Values Where You Use Them**.

## What this verifies

- a tuple can be decomposed into local bindings with a matching pattern;
- `_` ignores a tuple position without creating a binding;
- `for-in` can destructure tuple elements directly;
- tuple patterns in `switch` can combine literals, ranges, wildcards, and value bindings;
- `where` can refine a match after values are bound;
- `if case` uses the same pattern language;
- pattern shape must match the value being destructured.

## Running

From the repository root:

```bash
swift run molecule-002
```

Or open the package in Xcode and run the `molecule-002` executable.

The intentionally invalid shape-mismatch experiment is commented out in `main.swift`.

## Article

[Tuple Patterns: Destructure Values Where You Use Them](https://ivantokar.com/posts/tuple-patterns-destructure-values-where-you-use-them)
