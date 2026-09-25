import Foundation

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// Requires a Swift 6.2+ toolchain.

// MARK: - 1. MainActor-isolated object with isolated deinit

separator("1. isolated deinit")

@MainActor
final class Observation {
    private var events: [String] = []

    init() {
        events.append("created")
        print("Observation created")
    }

    func record(_ event: String) {
        events.append(event)
    }

    isolated deinit {
        // The deinitializer inherits the class isolation, so isolated state
        // can be accessed as part of destruction.
        print("Observation destroyed; events:", events)
    }
}

// MARK: - 2. Lifetime is still controlled by ownership

separator("2. Ownership controls lifetime")

@MainActor
func makeAndReleaseObservation() {
    var observation: Observation? = Observation()
    observation?.record("used")
    print("Dropping the last local strong reference")
    observation = nil
}

await makeAndReleaseObservation()

// @MainActor controls isolated access. ARC still determines when the
// object's final strong reference disappears.

// MARK: - 3. The release site need not be the isolation domain

separator("3. Transfer ownership")

@MainActor
final class Session: @unchecked Sendable {
    private let name: String

    init(name: String) {
        self.name = name
        print("Session created:", name)
    }

    isolated deinit {
        print("Session destroyed:", name)
    }
}

let session = await MainActor.run {
    Session(name: "demo")
}

// The example deliberately uses @unchecked Sendable only to make the
// ownership experiment possible from non-MainActor code. That annotation
// is not a recommendation for production design.

let task = Task.detached {
    var owned: Session? = session
    print("Detached task owns Session")
    owned = nil
    print("Detached task released its local reference")
}

await task.value

// The key distinction is conceptual:
// ownership determines when the object becomes eligible for destruction;
// isolation constrains where isolated destruction is allowed to execute.

// MARK: - 4. Explicit cleanup when timing matters

separator("4. Explicit lifecycle")

@MainActor
final class ExplicitResource {
    private(set) var isClosed = false

    func close() {
        guard !isClosed else { return }
        isClosed = true
        print("Resource closed explicitly")
    }

    isolated deinit {
        if !isClosed {
            print("Fallback cleanup during deinit")
        }
    }
}

await MainActor.run {
    let resource = ExplicitResource()
    resource.close()
}

// When callers must know exactly when a resource is released, an explicit
// close()/withResource-style API communicates that contract better than
// relying on deinitialization timing.

// MARK: - 5. Manual compiler experiment

separator("5. Compare ordinary deinit")

// Duplicate Observation under a different name and replace:
//
//     isolated deinit
//
// with:
//
//     deinit
//
// Then access MainActor-isolated mutable state from the deinitializer.
// With strict concurrency checking, inspect the diagnostics produced by
// your Swift toolchain. Keep the variant commented so this Playground
// remains runnable.

separator("Done")
print("All runtime experiments completed.")
