import Foundation

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// Requires a Swift 6.2+ toolchain.

// MARK: - 1. Reading contiguous storage through Span

separator("1. Array.span")

let bytes: [UInt8] = [10, 20, 30, 40]

// Use the borrowed value directly. A nonescapable Span cannot simply be
// stored wherever an ordinary collection value can.
print("count:", bytes.span.count)

for index in 0..<bytes.span.count {
    print(bytes.span[index])
}

// MARK: - 2. A function can consume Span directly

separator("2. Span parameter")

func checksum(_ bytes: Span<UInt8>) -> UInt64 {
    var result: UInt64 = 0

    for index in 0..<bytes.count {
        result &+= UInt64(bytes[index])
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

// The unsafe-buffer API expresses pointer validity with a closure scope.
// Span expresses borrowed access through a lifetime-dependent value.

// MARK: - 4. Copy values when ownership is needed

separator("4. Owned copy")

func ownedCopy(_ bytes: Span<UInt8>) -> [UInt8] {
    var result: [UInt8] = []
    result.reserveCapacity(bytes.count)

    for index in 0..<bytes.count {
        result.append(bytes[index])
    }

    return result
}

let copy = ownedCopy(bytes.span)
print("owned copy:", copy)

// MARK: - 5. Reusable algorithms can stay pointer-free

separator("5. Reusable borrowed algorithm")

func containsZero(_ bytes: Span<UInt8>) -> Bool {
    for index in 0..<bytes.count {
        if bytes[index] == 0 {
            return true
        }
    }
    return false
}

let noZero: [UInt8] = [1, 2, 3]
let hasZero: [UInt8] = [1, 0, 3]

print(containsZero(noZero.span))
print(containsZero(hasZero.span))

// MARK: - 6. Manual lifetime experiments

separator("6. Lifetime experiments")

// Experiment A: storing a lifetime-dependent Span can itself be rejected
// when the compiler cannot prove that the dependency is preserved.
//
// Try:
//
//     let escapedView = bytes.span
//     print(escapedView.count)
//
// In a Swift 6.2.1 script this produces a lifetime-dependent escape
// diagnostic. Compare that with passing bytes.span directly to checksum(_:).

// Experiment B: try returning a Span derived from local storage:
//
//     func invalidEscape() -> Span<UInt8> {
//         let local: [UInt8] = [1, 2, 3]
//         return local.span
//     }
//
// The compiler should reject the attempt to return a borrowed view whose
// dependency cannot outlive the function.

// MARK: - 7. Unsafe pointers still have a role

separator("7. Explicit pointer interoperability")

bytes.withUnsafeBufferPointer { buffer in
    print("baseAddress:", buffer.baseAddress as Any)
    print("count:", buffer.count)
}

separator("Done")
print("All runtime experiments completed.")
