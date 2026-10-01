# Molecules of Swift: Playground

**Molecules of Swift: Playground** is the executable companion to **[Molecules of Swift](https://ivantokar.com/tags/molecules-of-swift)**, where I explore small Swift features, patterns, and techniques that make code more expressive, precise, and idiomatic.

Despite the name, this repository is a **Swift Package**, not a collection of legacy `.playground` documents. Each Molecule is an executable target that can be built and run in Xcode or from the command line.

## Structure

```text
Package.swift
Sources/
├── Molecule001Tuples/
│   └── main.swift
└── Molecule002TuplePatterns/
    └── main.swift

001-tuples/
└── README.md
002-tuple-patterns/
└── README.md
```

The numbered README directories keep article-specific orientation and manual compiler experiments. The executable source lives under `Sources/`.

## Run it

Open the repository root in Xcode. Xcode recognizes `Package.swift` as a Swift package; select the executable scheme for the Molecule you want to explore and run it.

Or use SwiftPM directly:

```bash
swift build
swift run molecule-001
swift run molecule-002
```

Every executable must build and run successfully as committed. Examples that intentionally fail compilation stay commented out and include instructions for reproducing the compiler diagnostic manually.

## Verification

The package is designed to be executable evidence for the claims made in the articles. A Molecule is not complete merely because its source looks plausible: its active examples must pass the repository's build/run verification.

## Articles

Read the complete **[Molecules of Swift](https://ivantokar.com/tags/molecules-of-swift)** series on ivantokar.com.

The numbering follows publication order: article `#001` maps to `molecule-001`, article `#002` to `molecule-002`, and so on.

## License

See [LICENSE](LICENSE).
