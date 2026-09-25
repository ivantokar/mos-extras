import Foundation

enum DemoError: Error, CustomStringConvertible {
    case network
    case corruptedData

    var description: String {
        switch self {
        case .network: "Network error"
        case .corruptedData: "Corrupted data"
        }
    }
}

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// MARK: - 1. Independent properties can represent invalid combinations

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

print(impossibleState.isLoading, impossibleState.progress as Any,
      impossibleState.output as Any, impossibleState.error as Any)

// MARK: - 2. Structural combinations

separator("2. Structural combinations")

var combinations = 0
for isLoading in [false, true] {
    for hasProgress in [false, true] {
        for hasOutput in [false, true] {
            for hasError in [false, true] {
                combinations += 1
                print(combinations, isLoading, hasProgress, hasOutput, hasError)
            }
        }
    }
}
print("Total structural combinations:", combinations) // 16

// MARK: - 3. One enum represents the domain state

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

// There is no LoadState case that can simultaneously contain
// loading progress, a successful output, and an error.

// MARK: - 4. Associated data belongs to its case

separator("4. Associated values")

func inspect(_ state: LoadState<String>) {
    switch state {
    case .idle:
        print("Nothing has started")
    case let .loading(progress):
        print("Loading:", progress)
    case let .success(output):
        print("Success:", output.uppercased())
    case let .failure(error):
        print("Failure:", error)
    }
}

states.forEach(inspect)

// MARK: - 5. Pattern matching

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

// MARK: - 6. Consumers do not reconstruct enum state

separator("6. Property model vs enum model")

let propertyState = PropertyLoadState<String>(
    isLoading: false,
    progress: nil,
    output: "document.pdf",
    error: nil
)

if !propertyState.isLoading,
   propertyState.error == nil,
   let output = propertyState.output {
    print("Property model inferred success:", output)
}

let enumState: LoadState<String> = .success("document.pdf")
if case let .success(output) = enumState {
    print("Enum explicitly represents success:", output)
}

// MARK: - 7. Init validation alone does not protect mutable state

separator("7. Mutation can break an invariant")

struct MutableValidatedState<Output> {
    var isLoading: Bool
    var output: Output?
    var error: (any Error)?
}

var mutableState = MutableValidatedState<String>(
    isLoading: true,
    output: nil,
    error: nil
)

mutableState.output = "Document"
mutableState.error = DemoError.network
print(mutableState.isLoading, mutableState.output as Any, mutableState.error as Any)

// MARK: - 8. Controlled mutation

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

// These do not compile because setters are private:
// controlled.isLoading = true
// controlled.output = "something"

// MARK: - 9. Valid states do not imply valid transitions

separator("9. States vs transitions")

var unconstrainedState: LoadState<String> = .idle
unconstrainedState = .success("Done")
print(unconstrainedState)

// MARK: - 10. Transitions can be controlled separately

separator("10. Controlled transitions")

struct Loader<Output> {
    private(set) var state: LoadState<Output> = .idle

    mutating func start() {
        guard case .idle = state else { return print("start() rejected") }
        state = .loading(progress: 0)
    }

    mutating func updateProgress(_ progress: Double) {
        guard case .loading = state else { return print("updateProgress() rejected") }
        state = .loading(progress: progress)
    }

    mutating func complete(with output: Output) {
        guard case .loading = state else { return print("complete() rejected") }
        state = .success(output)
    }

    mutating func fail(with error: any Error) {
        guard case .loading = state else { return print("fail() rejected") }
        state = .failure(error)
    }
}

var loader = Loader<String>()
loader.complete(with: "Too early")
loader.start()
loader.updateProgress(0.5)
loader.complete(with: "document.pdf")
loader.fail(with: DemoError.network)
print("State:", loader.state)

// MARK: - 11. Associated values may need their own invariant

separator("11. Associated-value invariants")

let invalidProgress: LoadState<String> = .loading(progress: 42)
print(invalidProgress)

struct Progress {
    let value: Double

    init?(_ value: Double) {
        guard (0...1).contains(value) else { return nil }
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

// MARK: - 12. Independent flags can be correct

separator("12. Independent flags")

struct EditorPreferences {
    var showsLineNumbers: Bool
    var wrapsLines: Bool
    var highlightsCurrentLine: Bool
}

print(EditorPreferences(
    showsLineNumbers: true,
    wrapsLines: false,
    highlightsCurrentLine: true
))

// MARK: - 13. Exhaustive switch — manual compiler experiment

separator("13. Exhaustive switch")

enum SmallState {
    case idle
    case loading
    case success
    case failure

    // Manual experiment:
    // 1. Uncomment the next line.
    // 2. Observe that render(_:) becomes non-exhaustive.
    // case cancelled
}

func render(_ state: SmallState) {
    switch state {
    case .idle: print("Idle")
    case .loading: print("Loading")
    case .success: print("Success")
    case .failure: print("Failure")
    }
}

render(.success)

// MARK: - 14. default hides newly added cases

separator("14. Catch-all default")

enum StateWithCancellation {
    case idle, loading, success, failure, cancelled
}

func renderOnlySuccess(_ state: StateWithCancellation) {
    switch state {
    case .success: print("Success")
    default: print("Something else")
    }
}

renderOnlySuccess(.cancelled)

separator("Done")
print("All runtime experiments completed.")
