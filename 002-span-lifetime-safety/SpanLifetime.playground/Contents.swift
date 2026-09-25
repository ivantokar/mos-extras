import Foundation

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// Requires a Swift 6.2+ toolchain.

// MARK: - 1. Reading contiguous storage through Span

separator("1. Array.span")

let bytes: [UInt8] = [10, 20, 30, 40]
let view = bytes.span

print("count:", view.count)
for byte in view {
    print(byte)
}

// MARK: - 2. A function can consume Span directly

separator("2. Span parameter")

func checksum(_ bytes: Span<UInt8>) -> UInt64 {
    var result: UInt64 = 0
    for byte in bytes {
        result &+= UInt64(byte)
    }
    return result
}

print("checksum:", checksum(bytes.span))

// MARK: - 3. Compare with an unsafe-buffer scope

separator("3. Unsafe buffer scope")

let pointerChecksum = bytes.withUnsafeBufferPointer { buffer -> UInt64 in
    var result: UInt64 = 0
    for byte in buffer {
        result &+= UInt64(byte)
    }
    return result
}

print("pointer checksum:", pointerChecksum)
print("span checksum:", checksum(bytes.span))

// The unsafe-buffer API expresses pointer validity with the closure scope.
// Span expresses borrowed access in its type/lifetime model.

// MARK: - 4. Span does not become an owning collection

separator("4. Copy values when ownership is needed")

func ownedCopy(_ bytes: Span<UInt8>) -> [UInt8] {
    Array(bytes)
}

let copy = ownedCopy(bytes.span)
print("owned copy:", copy)

// The Array returned above owns its elements independently.
// The Span itself remains a view over storage owned elsewhere.

// MARK: - 5. Reusable algorithms can stay pointer-free

separator("5. Reusable borrowed algorithm")

func containsZero(_ bytes: Span<UInt8>) -> Bool {
    for byte in bytes where byte == 0 {
        return true
    }
    return false
}

print(containsZero([1, 2, 3].span))
print(containsZero([1, 0, 3].span))

// MARK: - 6. Manual lifetime experiment

separator("6. Lifetime experiment")

// Span is a nonescapable type. Code that attempts to let a Span outlive
// the storage it depends on should be rejected by the compiler.
//
// Try writing a helper that returns a Span derived from a locally-created
// Array, then inspect the compiler diagnostic:
//
// func invalidEscape() -> Span<UInt8> {
//     let local: [UInt8] = [1, 2, 3]
//     return local.span
// }
//
// Keep this experiment commented so the Playground remains runnable.

// MARK: - 7. Unsafe pointers still have a role

separator("7. Explicit pointer interoperability")

bytes.withUnsafeBufferPointer { buffer in
    print("baseAddress:", buffer.baseAddress as Any)
    print("count:", buffer.count)
}

// Span improves safe borrowed access. It does not remove APIs that need
// explicit pointer interoperability or manually managed memory.

separator("Done")
print("All runtime experiments completed.")
