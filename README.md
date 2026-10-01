# Molecules of Swift: Playground

**Molecules of Swift: Playground** is the executable companion to **[Molecules of Swift](https://ivantokar.com/tags/molecules-of-swift)**.

This repository is a **Swift Package**. Each Molecule is a self-contained directory containing its executable example and its README.

## Structure

```text
Package.swift
Molecules/
├── 001-tuples/
│   ├── README.md
│   └── main.swift
└── 002-tuple-patterns/
    ├── README.md
    └── main.swift
```

One Molecule, one directory.

## Run it

Open the repository root in Xcode and run the matching executable scheme, or use SwiftPM:

```bash
swift build
swift run molecule-001
swift run molecule-002
```

Every committed executable must build and run successfully. Intentionally non-compiling experiments stay commented out with reproduction instructions.

## Verification

The package is executable evidence for claims made in the articles. A Molecule is not complete because its source looks plausible: its active examples must pass build/run verification.

## Articles

Read the complete **[Molecules of Swift](https://ivantokar.com/tags/molecules-of-swift)** series on ivantokar.com.

## License

See [LICENSE](LICENSE).
