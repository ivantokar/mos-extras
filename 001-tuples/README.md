# Molecules of Swift #001 — Tuples: Group Values Without Creating a Type

Executable companion for **Tuples: Group Values Without Creating a Type**.

## What this verifies

- tuples group related values without declaring a nominal type;
- tuple labels and explicit tuple types;
- multiple return values;
- destructuring and ignored positions;
- optional tuples versus tuples of optionals;
- tuple pattern matching;
- direct tuple equality is distinct from `Equatable` / `Hashable` conformance;
- a named type provides a home for conformances and behavior.

## Running

From the repository root:

```bash
swift run molecule-001
```

Or open the package in Xcode and run the `molecule-001` executable.

The intentionally non-compiling `Equatable` and `Hashable` experiments are commented out in `Sources/Molecule001Tuples/main.swift`.

## Article

[Tuples: Group Values Without Creating a Type](https://ivantokar.com/posts/tuples-group-values-without-creating-a-type)
