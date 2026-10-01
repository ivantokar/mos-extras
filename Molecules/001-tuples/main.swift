// -----------------------------------------------------------------------------
// MOLECULES OF SWIFT · #001
// Tuples: Group Values Without Creating a Type
//
// Ivan Tokar · https://ivantokar.com
// Article: https://ivantokar.com/posts/tuples-group-values-without-creating-a-type
// Playground: https://github.com/ivantokar/mos-playground
// -----------------------------------------------------------------------------
//
// Explore. Change things. Break things. Learn why.

// MARK: - 1. Group values without declaring a new nominal type

// A tuple is useful when the relationship is local and the group itself does not
// need behavior or a reusable identity.
let response = (status: 200, message: "OK")
print(response.status, response.message)

// MARK: - 2. The tuple type can be explicit

// Labels are part of the tuple type, while an unlabeled tuple literal can still
// be assigned when contextual labels are known.
let bounds: (min: Int, max: Int) = (3, 9)
print(bounds.min, bounds.max)

// MARK: - 3. Return several related values as one compound value

func extremes(in values: [Int]) -> (min: Int, max: Int)? {
    guard let first = values.first else { return nil }

    var minValue = first
    var maxValue = first

    for value in values.dropFirst() {
        minValue = min(minValue, value)
        maxValue = max(maxValue, value)
    }

    return (minValue, maxValue)
}

if let result = extremes(in: [8, -6, 2, 109, 3, 71]) {
    print(result.min, result.max)
}

// MARK: - 4. Destructuring can ignore values you do not need

let user = (id: 42, name: "Mira", isAdmin: true)
let (id, _, isAdmin) = user
print(id, isAdmin)

// MARK: - 5. Optional tuple vs tuple of optionals

let maybePoint: (x: Int, y: Int)? = nil
let partialPoint: (x: Int?, y: Int?) = (x: 10, y: nil)
print(maybePoint as Any)
print(partialPoint as Any)

// MARK: - 6. Tuples compose with switch pattern matching

let point = (x: 0, y: 4)

switch point {
case (0, 0): print("origin")
case (0, _): print("y-axis")
case (_, 0): print("x-axis")
default: print("elsewhere")
}

// MARK: - 7. Direct equality does not imply protocol conformance

print((1, 2) == (1, 2))

// Manual compiler experiments:
//
// Uncomment to observe that a tuple cannot satisfy a generic Equatable
// requirement in the currently verified toolchains.
//
// func requiresEquatable<T: Equatable>(_ value: T) {}
// requiresEquatable((1, 2))
//
// Uncomment to observe the Hashable requirement of Dictionary.Key.
//
// let lookup: [(Int, Int): String] = [(1, 2): "value"]

// MARK: - 8. Know when the tuple has grown into a real type

struct Coordinate: Equatable, Hashable {
    let x: Int
    let y: Int
}

let coordinate = Coordinate(x: 2, y: 5)
print(coordinate)
