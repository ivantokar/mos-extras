// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MoleculesOfSwiftPlayground",
    products: [
        .executable(name: "molecule-001", targets: ["Molecule001Tuples"]),
        .executable(name: "molecule-002", targets: ["Molecule002TuplePatterns"]),
    ],
    targets: [
        .executableTarget(
            name: "Molecule001Tuples",
            path: "Molecules/001-tuples",
            exclude: ["README.md"]
        ),
        .executableTarget(
            name: "Molecule002TuplePatterns",
            path: "Molecules/002-tuple-patterns",
            exclude: ["README.md"]
        ),
    ]
)
