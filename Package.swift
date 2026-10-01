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
            path: "Sources/Molecule001Tuples"
        ),
        .executableTarget(
            name: "Molecule002TuplePatterns",
            path: "Sources/Molecule002TuplePatterns"
        ),
    ]
)
