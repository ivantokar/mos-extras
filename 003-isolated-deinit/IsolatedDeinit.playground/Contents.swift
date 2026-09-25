import Foundation

// Molecules of Swift #3 — isolated deinit
//
// Requires Swift 6.2+.
//
// Runtime sections compile as-is. Compiler experiments are kept commented
// because their purpose is to trigger Swift concurrency diagnostics.

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// MARK: - 1. isolated deinit inherits the containing actor isolation

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
        // This checks actor isolation directly rather than inferring it from a
        // thread name. It traps if this code is not isolated to MainActor.
        MainActor.preconditionIsolated()
        print("Observation destroyed; events:", events)
    }
}

@MainActor
func useObservation() {
    var observation: Observation? = Observation()
    observation?.record("used")
    print("Dropping the local strong reference")
    observation = nil
}

await MainActor.run {
    useObservation()
}

// MARK: - 2. ARC still decides when the last strong reference disappears

separator("2. Ownership still controls lifetime")

@MainActor
final class OwnedSession {
    let name: String

    init(name: String) {
        self.name = name
        print("Created:", name)
    }

    isolated deinit {
        MainActor.preconditionIsolated()
        print("Destroyed:", name)
    }
}

await MainActor.run {
    var first: OwnedSession? = OwnedSession(name: "shared")
    var second = first

    print("Dropping first reference")
    first = nil

    print("Second reference still exists:", second != nil)
    print("Dropping second reference")
    second = nil
}

// @MainActor constrains isolated access. ARC still decides when there are no
// strong references left and destruction becomes necessary.

// MARK: - 3. The final release can happen outside the isolation domain

separator("3. Final release outside MainActor")

@MainActor
final class DetachedSession: @unchecked Sendable {
    private let name: String

    init(name: String) {
        self.name = name
        print("Created on MainActor:", name)
    }

    isolated deinit {
        // Even when the final strong reference disappears in detached work,
        // isolated destruction must execute under MainActor isolation.
        MainActor.preconditionIsolated()
        print("isolated deinit on MainActor:", name)
    }
}

let detached = Task.detached {
    // Creation happens on MainActor, then ownership is returned to detached
    // work. @unchecked Sendable is used only to make this experiment possible;
    // it is NOT a recommendation for normal actor-isolated classes.
    let session = await MainActor.run {
        DetachedSession(name: "detached-owner")
    }

    print("Detached task now holds the only strong reference")
    _ = session

    // session is released when this detached task scope ends.
}

await detached.value

// This separates two questions:
//   ARC / ownership -> when the final reference disappears
//   actor isolation -> where isolated destruction is allowed to execute

// MARK: - 4. Explicit cleanup is clearer when timing is part of the contract

separator("4. Explicit lifecycle")

@MainActor
final class ExplicitResource {
    private(set) var isClosed = false

    func close() {
        guard !isClosed else {
            return
        }

        isClosed = true
        print("Resource closed explicitly")
    }

    isolated deinit {
        MainActor.preconditionIsolated()

        if !isClosed {
            print("Fallback cleanup during deinit")
        }
    }
}

await MainActor.run {
    let resource = ExplicitResource()
    resource.close()
    print("Caller knows cleanup completed before this line")
}

// isolated deinit is useful for cleanup tied to object lifetime. An explicit
// API is a better fit when callers must know exactly when cleanup completed.

// MARK: - 5. Async follow-up should capture values, not self

separator("5. Copy values for async follow-up")

actor DeinitLog {
    static let shared = DeinitLog()

    func write(_ message: String) {
        print("log:", message)
    }
}

@MainActor
final class ClickCounter {
    private var count = 3

    isolated deinit {
        let finalCount = count

        // The task captures copied data. It does not capture self and does not
        // try to extend the lifetime of an object that is deinitializing.
        Task {
            await DeinitLog.shared.write("final count = \(finalCount)")
        }
    }
}

await MainActor.run {
    _ = ClickCounter()
}

// Give the unstructured task above a chance to execute in this script.
try? await Task.sleep(for: .milliseconds(50))

// MARK: - 6. Manual compiler experiment: ordinary deinit is nonisolated

// Compile in Swift 6 language mode with strict concurrency checking. Token is
// intentionally non-Sendable. Accessing it from the plain deinit should produce
// a diagnostic because a synchronous deinitializer is nonisolated by default.
//
// final class Token {
//     func stop() {}
// }
//
// @MainActor
// final class OrdinaryDeinit {
//     let token = Token()
//
//     deinit {
//         token.stop() // expected compiler error in Swift 6 mode
//     }
// }

// MARK: - 7. Manual comparison: make the deinitializer isolated

// Change the example above to:
//
// @MainActor
// final class IsolatedDeinitVersion {
//     let token = Token()
//
//     isolated deinit {
//         token.stop()
//     }
// }
//
// The access is now performed under the class isolation.

separator("Done")
print("All runtime experiments completed.")
