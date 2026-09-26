import Foundation

protocol DisplayNamed {
    var displayName: String { get }
}

@MainActor
final class ScreenModel: @MainActor DisplayNamed, @MainActor Equatable {
    var displayName: String

    init(_ displayName: String) {
        self.displayName = displayName
    }

    static func == (lhs: ScreenModel, rhs: ScreenModel) -> Bool {
        lhs.displayName == rhs.displayName
    }
}

func acceptsDisplayNamed<T: DisplayNamed>(_ value: T) {
    print(value.displayName)
}

@MainActor
func runExamples() {
    let first = ScreenModel("Library")
    let same = ScreenModel("Library")
    let different = ScreenModel("Reader")

    acceptsDisplayNamed(first)
    print(first == same)
    print([first].contains(same))
    print([first].contains(different))

    let erased: any DisplayNamed = first
    print(erased.displayName)
}

struct ExportRecord: @MainActor DisplayNamed {
    let displayName: String
}

@MainActor
func runStructExample() {
    acceptsDisplayNamed(ExportRecord(displayName: "Export"))
}

await MainActor.run {
    runExamples()
    runStructExample()
}

// Manual compiler experiment 1:
//
// nonisolated func useOutsideMainActor(_ value: ScreenModel) {
//     acceptsDisplayNamed(value)
// }
//
// Swift 6.2 rejects this because the MainActor-isolated conformance
// cannot be used from a nonisolated context.

// Manual compiler experiment 2:
//
// Remove @MainActor from the DisplayNamed and Equatable conformances.
// The requirements are nonisolated, so they cannot read MainActor-isolated
// instance state.

// Manual compiler experiment 3:
//
// func requiresSendableMetatype<T: DisplayNamed & SendableMetatype>(_ value: T) {}
//
// @MainActor
// func trySendableMetatype(_ value: ScreenModel) {
//     requiresSendableMetatype(value)
// }
//
// Swift rejects an isolated conformance when the same generic parameter
// must also satisfy SendableMetatype.
