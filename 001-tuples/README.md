# Molecules of Swift #001 — Tuples: Group Values Without Creating a Type

Companion Playground for the article **Tuples: Group Values Without Creating a Type**.

## What this verifies

- Tuples group heterogeneous values into one compound value.
- Tuple elements can be labeled and accessed by label.
- Functions can return optional labeled tuples.
- Destructuring can ignore unwanted elements with `_`.
- `(T, U)?` and `(T?, U?)` model different states.
- Tuple patterns compose with `switch`.
- Direct tuple equality does not imply `Equatable` or `Hashable` conformance.
- A named struct is the stronger boundary once grouped data needs identity, behavior, invariants, or conformances.

## Running

Open `Tuples.playground` in Xcode and run the Playground.

The active examples compile and print their results directly.

## Manual compiler experiment

In section 7, uncomment the generic `Equatable` experiment or the tuple-key dictionary. With Swift 6.4, the compiler rejects the tuple because tuple types still do not automatically conform to `Equatable` or `Hashable`.

## Article

Read the article: [Tuples: Group Values Without Creating a Type](https://ivantokar.com/posts/tuples-group-values-without-creating-a-type)
