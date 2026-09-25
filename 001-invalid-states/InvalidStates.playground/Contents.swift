import Foundation

// Molecules of Swift #1 — Associated Values
//
// This Playground is intentionally broader than the article. Each section
// isolates one claim so you can change the code and see which guarantees come
// from Swift's type system and which rules still belong to your own model.

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

enum DemoError: Error, CustomStringConvertible {
    case network
    case corruptedData

    var description: String {
        switch self {
        case .network:
            return "Network error"
        case .corruptedData:
            return "Corrupted data"
        }
    }
}

// MARK: - 1. Independent properties can represent impossible domain states

separator("1. Independent properties")

struct PropertyLoadState<Output> {
    var isLoading: Bool
    var progress: Double?
    var output: Output?
    var error: (any Error)?
}

let impossibleState = PropertyLoadState(
    isLoading: true,
    progress: 0.7,
    output: "Loaded document",
    error: DemoError.network
)

print("loading:", impossibleState.isLoading)
print("progress:", impossibleState.progress as Any)
print("output:", impossibleState.output as Any)
print("error:", impossibleState.error as Any)

// This compiles because Swift sees four independent stored properties.
// The compiler has no knowledge of a domain rule such as:
//
//   loading -> may have progress, but no output or error yet
//   success -> has output, but is not loading and has no error
//   failure -> has error, but no output
//
// If those rules matter, the type above does not encode them.

// MARK: - 2. Count only the structural combinations

separator("2. Structural combinations")

var combinationCount = 0

for isLoading in [false, true] {
    for hasProgress in [false, true] {
        for hasOutput in [false, true] {
            for hasError in [false, true] {
                combinationCount += 1
                print(
                    "\(combinationCount):",
                    "loading=\(isLoading)",
                    "progress=\(hasProgress)",
                    "output=\(hasOutput)",
                    "error=\(hasError)"
                )
            }
        }
    }
}

print("Total structural combinations:", combinationCount)

// We are counting only true/false and nil/non-nil shapes here.
// Double, String and Error obviously have many possible values of their own.
// The point is that independent properties create a product of combinations.

// MARK: - 3. Encode the alternatives directly

separator("3. Enum state")

enum LoadState<Output> {
    case idle
    case loading(progress: Double)
    case success(Output)
    case failure(any Error)
}

let states: [LoadState<String>] = [
    .idle,
    .loading(progress: 0.7),
    .success("Loaded document"),
    .failure(DemoError.network)
]

states.forEach { print($0) }

// There is no LoadState case that carries loading progress, successful output,
// and an error at the same time. That combination is not part of the type.

// MARK: - 4. Associated values belong to their matching case

separator("4. Associated values")

func inspect(_ state: LoadState<String>) {
    switch state {
    case .idle:
        print("Nothing has started")

    case let .loading(progress):
        // progress is a Double here, not Double?. Matching the case proves it
        // exists and gives us the associated value directly.
        print("Loading:", progress)

    case let .success(output):
        // output is a String here, not String?.
        print("Success:", output.uppercased())

    case let .failure(error):
        print("Failure:", error)
    }
}

states.forEach(inspect)

// MARK: - 5. Pattern matching can focus on one alternative

separator("5. Pattern matching")

let currentState: LoadState<String> = .loading(progress: 0.55)

if case let .loading(progress) = currentState {
    print("Current progress:", progress)
}

if case let .success(output) = currentState {
    print("Output:", output)
} else {
    print("There is no success output in this state")
}

// MARK: - 6. Compare reconstruction with direct representation

separator("6. Reconstructing state")

let propertyState = PropertyLoadState<String>(
    isLoading: false,
    progress: nil,
    output: "document.pdf",
    error: nil
)

// A consumer of the property model has to know the relationship between fields.
if !propertyState.isLoading,
   propertyState.error == nil,
   let output = propertyState.output {
    print("Property model inferred success:", output)
}

// In the enum model the relationship is already represented by the case.
let enumState: LoadState<String> = .success("document.pdf")
if case let .success(output) = enumState {
    print("Enum explicitly represents success:", output)
}

// MARK: - 7. Init validation is not enough when mutation remains unrestricted

separator("7. Mutation can break an invariant")

struct MutableValidatedState<Output> {
    var isLoading: Bool
    var output: Output?
    var error: (any Error)?

    init(isLoading: Bool, output: Output?, error: (any Error)?) {
        // Imagine perfect validation here.
        self.isLoading = isLoading
        self.output = output
        self.error = error
    }
}

var mutableState = MutableValidatedState<String>(
    isLoading: true,
    output: nil,
    error: nil
)

// Even if init validated the starting state, public setters can immediately
// create another combination afterward.
mutableState.output = "Document"
mutableState.error = DemoError.network

print(mutableState.isLoading, mutableState.output as Any, mutableState.error as Any)

// MARK: - 8. Controlled mutation is another valid design

separator("8. Controlled mutation")

struct ControlledState<Output> {
    private(set) var isLoading = false
    private(set) var output: Output?
    private(set) var error: (any Error)?

    mutating func start() {
        isLoading = true
        output = nil
        error = nil
    }

    mutating func succeed(with output: Output) {
        isLoading = false
        self.output = output
        error = nil
    }

    mutating func fail(with error: any Error) {
        isLoading = false
        output = nil
        self.error = error
    }
}

var controlled = ControlledState<String>()
controlled.start()
controlled.succeed(with: "document.pdf")
print(controlled.isLoading, controlled.output as Any, controlled.error as Any)

// Manual compiler experiment:
// Uncomment either line. Both should fail because the setters are private.
//
// controlled.isLoading = true
// controlled.output = "something"

// MARK: - 9. An enum does not enforce workflow transitions

separator("9. States vs transitions")

var unconstrainedState: LoadState<String> = .idle
unconstrainedState = .success("Done")
print(unconstrainedState)

// Both values are valid LoadState values, so the assignment is valid Swift.
// The enum does not know whether idle -> success is allowed in your workflow.

// MARK: - 10. Transitions can be controlled separately

separator("10. Controlled transitions")

struct Loader<Output> {
    private(set) var state: LoadState<Output> = .idle

    mutating func start() {
        guard case .idle = state else {
            print("start() rejected")
            return
        }
        state = .loading(progress: 0)
    }

    mutating func updateProgress(_ progress: Double) {
        guard case .loading = state else {
            print("updateProgress() rejected")
            return
        }
        state = .loading(progress: progress)
    }

    mutating func complete(with output: Output) {
        guard case .loading = state else {
            print("complete() rejected")
            return
        }
        state = .success(output)
    }

    mutating func fail(with error: any Error) {
        guard case .loading = state else {
            print("fail() rejected")
            return
        }
        state = .failure(error)
    }
}

var loader = Loader<String>()
loader.complete(with: "Too early") // rejected: still idle
loader.start()
loader.updateProgress(0.5)
loader.complete(with: "document.pdf")
loader.fail(with: DemoError.network) // rejected: no longer loading
print("State:", loader.state)

// MARK: - 11. Associated values can need their own invariant

separator("11. Associated-value invariants")

let invalidProgress: LoadState<String> = .loading(progress: 42)
print(invalidProgress)

// LoadState guarantees that progress exists only in .loading.
// It does not guarantee that the Double itself is between 0 and 1.

struct Progress {
    let value: Double

    init?(_ value: Double) {
        guard (0...1).contains(value) else {
            return nil
        }
        self.value = value
    }
}

enum StrictLoadState<Output> {
    case idle
    case loading(progress: Progress)
    case success(Output)
    case failure(any Error)
}

print("Progress(0.75):", Progress(0.75) as Any)
print("Progress(42):", Progress(42) as Any)

// MARK: - 12. Independent properties can still be the correct model

separator("12. Independent flags")

struct EditorPreferences {
    var showsLineNumbers: Bool
    var wrapsLines: Bool
    var highlightsCurrentLine: Bool
}

let preferences = EditorPreferences(
    showsLineNumbers: true,
    wrapsLines: false,
    highlightsCurrentLine: true
)

print(preferences)

// All three settings can vary independently. In this model, the product of
// combinations is useful rather than accidental, so a struct is a good fit.

// MARK: - 13. Exhaustive switch — manual compiler experiment

separator("13. Exhaustive switch")

enum SmallState {
    case idle
    case loading
    case success
    case failure

    // Manual experiment:
    // 1. Uncomment the next line.
    // 2. The render(_:) function below should stop compiling because its
    //    switch no longer handles every case.
    // case cancelled
}

func render(_ state: SmallState) {
    switch state {
    case .idle:
        print("Idle")
    case .loading:
        print("Loading")
    case .success:
        print("Success")
    case .failure:
        print("Failure")
    }
}

render(.success)

// MARK: - 14. A catch-all default changes that compiler feedback

separator("14. Catch-all default")

enum StateWithCancellation {
    case idle
    case loading
    case success
    case failure
    case cancelled
}

func renderOnlySuccess(_ state: StateWithCancellation) {
    switch state {
    case .success:
        print("Success")
    default:
        print("Something else")
    }
}

renderOnlySuccess(.cancelled)

// Because default already handles every other case, adding more cases to the
// enum does not force this switch to change.

// MARK: - 15. Different cases can carry different payload shapes

separator("15. Different payload shapes")

enum SearchTarget {
    case all
    case author(id: UUID)
    case tag(String)
    case dateRange(from: Date, to: Date)
}

let targets: [SearchTarget] = [
    .all,
    .author(id: UUID()),
    .tag("swift"),
    .dateRange(from: .distantPast, to: .distantFuture)
]

for target in targets {
    switch target {
    case .all:
        print("all")
    case let .author(id):
        print("author:", id)
    case let .tag(tag):
        print("tag:", tag)
    case let .dateRange(from, to):
        print("date range:", from, to)
    }
}

// Each case can define a different payload shape. Matching the case narrows
// the value to that shape and exposes only the data that belongs there.

// MARK: - 16. Optional uses the same associated-value idea

separator("16. Optional as an enum-shaped model")

let maybeName: String? = "Ivan"

switch maybeName {
case .none:
    print("No name")
case let .some(name):
    print("Name:", name)
}

// Optional is represented by two alternatives: no value, or a wrapped value.
// The wrapped data exists only in the .some case, which is the same modeling
// idea used by custom enums with associated values.

separator("Done")
print("All runtime experiments completed.")
