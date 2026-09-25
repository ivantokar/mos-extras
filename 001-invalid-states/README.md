# Molecules of Swift #1 — Invalid States

Companion Playground for the article:

**When Multiple Optionals Actually Describe One State**

## What this verifies

- independent stored properties can represent domain-state combinations that the domain does not consider valid;
- an enum with associated values can remove those combinations from the type;
- matching an enum case makes its associated values directly available;
- consumers no longer need to reconstruct enum state from several independent properties;
- initializer validation alone does not protect an invariant when mutation remains unrestricted;
- controlled setters or operations can protect a property-based model;
- enums describe valid states but do not automatically enforce valid transitions;
- transition rules can be modeled separately;
- associated values may still need their own value-level validation;
- independent flags are still a good struct model when all combinations are meaningful;
- exhaustive `switch` statements surface newly added enum cases;
- a catch-all `default` removes that compiler assistance.

## Running

Open `InvalidStates.playground` in Xcode and run the Playground.

The runtime experiments print their results directly and are documented in the source.

## Manual compiler experiments

The Playground also includes intentionally inactive compiler experiments:

1. try writing to `private(set)` properties from outside the type;
2. add `case cancelled` to `SmallState` and observe that `render(_:)` is no longer exhaustive;
3. compare that behavior with the switch that already uses `default`.

## Article

Part of the Molecules of Swift series.

[Article URL once published]
