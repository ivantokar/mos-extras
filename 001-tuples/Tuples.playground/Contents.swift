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

import Foundation

// MARK: - 1. Group values without declaring a new nominal type

// A tuple is useful when the relationship is local and the group itself does not need behavior or a reusable identity.
let response = (status: 200, message: "OK")
print(response.status, response.message)

// MARK: - 2. The tuple type can be explicit

// Labels are part of the tuple type, while an unlabeled tuple literal can still be assigned when the contextual labels are known.
let bounds: (min: Int, max: Int) = (3, 9)
print(bounds.min, bounds.max)

// MARK: - 3. A function can return several related values as one compound value

// This keeps a tiny local result lightweight when introducing a struct would add a name with little reuse.
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

// The underscore makes the intent explicit without introducing a throwaway binding.
let user = (id: 42, name: "Mira", isAdmin: true)
let (id, _, isAdmin) = user
print(id, isAdmin)

// MARK: - 5. A whole optional tuple is different from a tuple of optionals

// The first models whether the grouped result exists; the second always has a tuple, but each element may be absent independently.
let maybePoint: (x: Int, y: Int)? = nil
let partialPoint: (x: Int?, y: Int?) = (x: 10, y: nil)
print(maybePoint as Any)
print(partialPoint as Any)

// MARK: - 6. Tuples compose naturally with switch pattern matching

// Each position can use a different pattern, which makes tuples useful for small local classifications.
let point = (x: 0, y: 4)
switch point {
case (0, 0): print("origin")
case (0, _): print("y-axis")
case (_, 0): print("x-axis")
default: print("elsewhere")
}

// MARK: - 7. Equality syntax exists, but tuples are not generally Equatable-conforming values

// Direct tuple equality is supported for compatible tuples. Do not infer from this that (Int, Int) can satisfy a generic T: Equatable constraint.
print((1, 2) == (1, 2))

// Manual compiler experiment:
// Uncomment these two lines.
// In Swift 6.2.1, the tuple cannot satisfy the generic Equatable conformance requirement.
//
// func requiresEquatable<T: Equatable>(_ value: T) {}
// requiresEquatable((1, 2))

// MARK: - 8. Know when the tuple has grown into a real type

// A named struct gives the concept identity and a home for invariants, methods, conformances, and documentation when it starts crossing API boundaries.
struct Coordinate: Equatable, Hashable {
    let x: Int
    let y: Int
}
let coordinate = Coordinate(x: 2, y: 5)
print(coordinate)
