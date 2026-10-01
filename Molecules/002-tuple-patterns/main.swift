// -----------------------------------------------------------------------------
// MOLECULES OF SWIFT · #002
// Tuple Patterns: Destructure Values Where You Use Them
//
// Ivan Tokar · https://ivantokar.com
// Article: https://ivantokar.com/posts/tuple-patterns-destructure-values-where-you-use-them
// Playground: https://github.com/ivantokar/mos-playground
// -----------------------------------------------------------------------------
//
// Explore. Change things. Break things. Learn why.

// MARK: - 1. Decompose a tuple into local bindings

let response = (status: 200, message: "OK")
let (status, message) = response
print(status, message)

// MARK: - 2. Ignore a position with the wildcard pattern

let user = (id: 42, name: "Mira", isAdmin: true)
let (id, _, isAdmin) = user
print(id, isAdmin)

// MARK: - 3. Destructure directly in a for-in loop

let scores = [
    (name: "Mira", score: 91),
    (name: "Noah", score: 84),
    (name: "Ava", score: 97),
]

for (name, score) in scores {
    print("\(name): \(score)")
}

// MARK: - 4. Mix values, ranges, and wildcards

let point = (x: 0, y: 4)

switch point {
case (0, 0): print("origin")
case (0, _): print("y-axis")
case (_, 0): print("x-axis")
case (-5...5, -5...5): print("inside the box")
default: print("outside")
}

// MARK: - 5. Bind values only when the pattern matches

let anotherPoint = (x: 8, y: 0)

switch anotherPoint {
case (let x, 0): print("x-axis at \(x)")
case (0, let y): print("y-axis at \(y)")
case let (x, y): print("elsewhere at \(x), \(y)")
}

// MARK: - 6. Refine a pattern with where

let vector = (x: 3, y: -3)

switch vector {
case let (x, y) where x == y: print("main diagonal")
case let (x, y) where x == -y: print("opposite diagonal")
case let (x, y): print("ordinary vector: \(x), \(y)")
}

// MARK: - 7. The same pattern language works with if case

let sample = (x: 12, y: 100)

if case (let x, 100) = sample {
    print("y = 100 at x = \(x)")
}

// MARK: - 8. Manual compiler experiment

// Uncomment to see the diagnostic for a pattern whose shape does not match.
//
// let (code, text, extra) = response
