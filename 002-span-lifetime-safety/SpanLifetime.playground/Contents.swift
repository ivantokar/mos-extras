import Foundation

// Molecules of Swift #2 — Span Lifetime Safety
//
// Requires Swift 6.2+.
//
// Runtime sections compile as-is. Compiler experiments are kept commented
// because their purpose is to trigger diagnostics.

func separator(_ title: String) {
    print("\n--- \(title) ---")
}

// MARK: - 1. Array can vend a Span without exposing an unsafe pointer

separator("1. Array.span")

func showBasicSpanAccess() {
    let bytes: [UInt8] = [10, 20, 30, 40]
    let span = bytes.span

    print("count:", span.count)

    for index in 0..<span.count {
        print("byte[\(index)]:", span[index])
    }
}

showBasicSpanAccess()

// Array still owns the storage. Span is a borrowed view of those elements.
// The important part is the lifetime relationship to the binding that vended
// the Span, not a transfer of ownership.

// MARK: - 2. Functions can accept Span directly

separator("2. Span parameter")

func checksum(_ bytes: Span<UInt8>) -> UInt64 {
    var result: UInt64 = 0

    for index in 0..<bytes.count {
        result &+= UInt64(bytes[index])
    }

    return result
}

func showSpanParameter() {
    let bytes: [UInt8] = [10, 20, 30, 40]
    print("checksum:", checksum(bytes.span))
}

showSpanParameter()

// The function does not need UnsafeBufferPointer just to read contiguous
// elements, and it does not take ownership of the Array's storage.

// MARK: - 3. Compare with a closure-scoped unsafe buffer

separator("3. Span vs withUnsafeBufferPointer")

func unsafeChecksum(_ bytes: UnsafeBufferPointer<UInt8>) -> UInt64 {
    var result: UInt64 = 0

    for byte in bytes {
        result &+= UInt64(byte)
    }

    return result
}

func compareAccessModels() {
    let bytes: [UInt8] = [10, 20, 30, 40]

    let pointerValue = bytes.withUnsafeBufferPointer { buffer in
        unsafeChecksum(buffer)
    }

    let spanValue = checksum(bytes.span)

    print("unsafe buffer checksum:", pointerValue)
    print("Span checksum:", spanValue)
}

compareAccessModels()

// withUnsafeBufferPointer expresses validity through a closure boundary.
// Array.span returns a lifetime-dependent value instead. The compiler tracks
// the borrowing relationship to the source binding.

// MARK: - 4. A Span can live in a local scope while the source is borrowed

separator("4. Local borrow")

func showLocalBorrow() {
    let bytes: [UInt8] = [1, 2, 3]
    let span = bytes.span

    print("first:", span[0])
    print("last:", span[span.count - 1])
}

showLocalBorrow()

// Span is Copyable but ~Escapable. Local copies are fine while their lifetime
// dependency remains valid.

// MARK: - 5. Ending the borrow allows later mutation

separator("5. Borrow scope and mutation")

func showBorrowEndingBeforeMutation() {
    var bytes: [UInt8] = [1, 2, 3]

    do {
        let span = bytes.span
        print("before mutation:", span[0])
    } // the borrow of bytes ends here

    bytes.append(4)
    print("after borrow ended:", bytes)
}

showBorrowEndingBeforeMutation()

// The do block is not Span-specific syntax. It simply makes the end of the
// local borrow obvious before the Array is mutated.

// MARK: - 6. Copy explicitly when independent ownership is required

separator("6. Owned copy")

func ownedCopy(_ bytes: Span<UInt8>) -> [UInt8] {
    var result: [UInt8] = []
    result.reserveCapacity(bytes.count)

    for index in 0..<bytes.count {
        result.append(bytes[index])
    }

    return result
}

func showOwnedCopy() {
    let bytes: [UInt8] = [7, 8, 9]
    let copy = ownedCopy(bytes.span)
    print("owned copy:", copy)
}

showOwnedCopy()

// The returned Array owns its elements independently. This is the explicit
// point where the code stops borrowing and chooses to copy.

// MARK: - 7. Reusable algorithms can stay pointer-free

separator("7. Borrowed algorithms")

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

print("contains zero:", containsZero(noZero.span))
print("contains zero:", containsZero(hasZero.span))

// MARK: - 8. Unsafe pointer interoperability still exists

separator("8. Explicit pointer interoperability")

let pointerBytes: [UInt8] = [11, 12, 13]
pointerBytes.withUnsafeBufferPointer { buffer in
    print("baseAddress:", buffer.baseAddress as Any)
    print("count:", buffer.count)
}

// Span is not a replacement for every pointer API. C interoperability,
// manually managed memory, and APIs that fundamentally require addresses can
// still need UnsafePointer-family types.

// MARK: - 9. Manual compiler experiment: mutation while borrowed

// Uncomment this function. Swift 6.2 should report an overlapping-access error
// because span still borrows bytes when bytes.append(4) asks for exclusive
// mutable access.
//
// func mutationWhileBorrowed() {
//     var bytes: [UInt8] = [1, 2, 3]
//     let span = bytes.span
//     print(span[0])
//
//     bytes.append(4) // expected: overlapping access diagnostic
//
//     print(span[0])
// }

// MARK: - 10. Manual compiler experiment: returning a Span

// Span is ~Escapable. An ordinary function cannot simply return a Span without
// expressing an appropriate lifetime relationship for the result. Uncomment
// this function and inspect the compiler diagnostic.
//
// func invalidEscape() -> Span<UInt8> {
//     let local: [UInt8] = [1, 2, 3]
//     return local.span
// }

// MARK: - 11. Manual compiler experiment: top-level storage

// In script/Playground contexts, the compiler may reject a top-level binding
// like this because the lifetime-dependent value escapes the scoped access used
// to vend it.
//
// let topLevelBytes: [UInt8] = [1, 2, 3]
// let topLevelSpan = topLevelBytes.span
// print(topLevelSpan[0])

separator("Done")
print("All runtime experiments completed.")
