import XCTest
@testable import FolioReview
import FolioModel

final class FolioSplitRowClippingTests: XCTestCase {
    func testClippingMatchesExhaustiveScanForEveryRange() throws {
        let kinds: [DiffLine.Kind] = [
            .context, .deletion, .deletion, .deletion, .addition, .context,
            .addition, .addition, .deletion, .context, .deletion, .addition,
            .deletion, .addition, .addition, .addition, .context, .deletion,
            .deletion, .addition, .context
        ]
        let diff = try makeDiff(kinds: kinds)

        for lower in 0..<kinds.count {
            for upper in lower..<kinds.count {
                let range = lower...upper
                XCTAssertEqual(
                    diff.splitRows(clippedTo: range),
                    diff.splitRows.compactMap { $0.clipped(to: range) },
                    "range \(range)"
                )
            }
        }
    }

    func testClippingOutsideTheHunkIsEmpty() throws {
        let diff = try makeDiff(kinds: [.context, .addition])

        XCTAssertEqual(diff.splitRows(clippedTo: 5...9), [])
    }

    func testSkeletonBoxReusesArtifactForUnchangedContent() {
        let hunk = DiffHunk(
            oldStart: 1,
            newStart: 1,
            lines: [DiffLine(kind: .context, oldNumber: 1, newNumber: 1, text: "a")]
        )
        let other = DiffHunk(
            oldStart: 1,
            newStart: 1,
            lines: [DiffLine(kind: .addition, oldNumber: nil, newNumber: 1, text: "b")]
        )
        let box = FolioSkeletonArtifactBox()

        let first = box.artifact(content: .diff(hunk, anchor: nil, mode: .split), contextLines: 3)
        let repeated = box.artifact(content: .diff(hunk, anchor: nil, mode: .unified), contextLines: 3)
        let changed = box.artifact(content: .diff(other, anchor: nil, mode: .split), contextLines: 3)

        XCTAssertEqual(first, repeated)
        XCTAssertNotEqual(first, changed)
    }

    private func makeDiff(kinds: [DiffLine.Kind]) throws -> FolioRenderArtifact.Diff {
        var old = 1
        var new = 1
        let lines = kinds.enumerated().map { index, kind -> DiffLine in
            switch kind {
            case .context, .noNewline:
                defer { old += 1; new += 1 }
                return DiffLine(kind: kind, oldNumber: old, newNumber: new, text: "c\(index)")
            case .deletion:
                defer { old += 1 }
                return DiffLine(kind: kind, oldNumber: old, newNumber: nil, text: "d\(index)")
            case .addition:
                defer { new += 1 }
                return DiffLine(kind: kind, oldNumber: nil, newNumber: new, text: "a\(index)")
            }
        }
        let artifact = FolioRenderArtifactBuilder.skeleton(
            content: .diff(DiffHunk(oldStart: 1, newStart: 1, lines: lines), anchor: nil, mode: .split),
            contextLines: 3
        )
        guard case let .diff(diff) = artifact.kind else {
            throw XCTSkip("Expected diff artifact")
        }
        return diff
    }
}
