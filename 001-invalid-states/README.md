# Molecules of Swift #1 — Invalid States

Companion Playground for the article:

**When Multiple Optionals Actually Describe One State**

## What this verifies

- independent properties can represent invalid domain-state combinations;
- an enum with associated values can make those combinations unrepresentable;
- associated values are available only for the matching enum case;
- constructor validation alone does not protect invariants if mutation remains unrestricted;
- enums describe valid states, but do not automatically enforce valid transitions;
- associated values may still require their own validation;
- exhaustive `switch` statements help propagate enum changes through the codebase;
- a catch-all `default` prevents that compiler assistance.

## Running

Open `InvalidStates.playground` in Xcode and run the Playground.

Most examples compile and print their results directly.

## Manual compiler experiments

In experiment 13, add `case cancelled` to `SmallState`. Xcode should report that `render(_:)` is no longer exhaustive. Compare that with experiment 14, where `default` absorbs newly added cases.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
