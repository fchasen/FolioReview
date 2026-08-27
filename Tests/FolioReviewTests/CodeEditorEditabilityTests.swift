#if os(macOS)
import AppKit
import FolioHighlight
import SwiftUI
import XCTest
@testable import FolioReview

@MainActor
final class CodeEditorEditabilityTests: XCTestCase {
    func testEditorIsEditableByDefault() {
        XCTAssertEqual(hostedEditorIsEditable(isEditable: true, isEnabled: true), true)
    }

    func testDisabledAncestorMakesEditorReadOnly() {
        XCTAssertEqual(hostedEditorIsEditable(isEditable: true, isEnabled: false), false)
    }

    func testExplicitIsEditableFalseMakesEditorReadOnly() {
        XCTAssertEqual(hostedEditorIsEditable(isEditable: false, isEnabled: true), false)
    }

    func testReadOnlyEditorStaysSelectable() {
        XCTAssertEqual(hostedEditor(isEditable: true, isEnabled: false)?.isSelectable, true)
    }

    func testTogglingEnabledReusesTheSameTextView() {
        let host = hostingView(isEditable: true, isEnabled: true)
        guard let textView = firstTextView(in: host) else {
            return XCTFail("no text view was mounted")
        }
        XCTAssertTrue(textView.isEditable)

        host.rootView = editor(isEditable: true, isEnabled: false)
        host.layoutSubtreeIfNeeded()
        XCTAssertIdentical(firstTextView(in: host), textView)
        XCTAssertFalse(textView.isEditable)
        XCTAssertTrue(textView.isSelectable)

        host.rootView = editor(isEditable: true, isEnabled: true)
        host.layoutSubtreeIfNeeded()
        XCTAssertIdentical(firstTextView(in: host), textView)
        XCTAssertTrue(textView.isEditable)
    }

    private func hostedEditorIsEditable(isEditable: Bool, isEnabled: Bool) -> Bool? {
        hostedEditor(isEditable: isEditable, isEnabled: isEnabled)?.isEditable
    }

    private func hostedEditor(isEditable: Bool, isEnabled: Bool) -> NSTextView? {
        firstTextView(in: hostingView(isEditable: isEditable, isEnabled: isEnabled))
    }

    private func hostingView(isEditable: Bool, isEnabled: Bool) -> NSHostingView<EditorProbe> {
        let host = NSHostingView(rootView: editor(isEditable: isEditable, isEnabled: isEnabled))
        host.frame = NSRect(x: 0, y: 0, width: 320, height: 120)
        host.layoutSubtreeIfNeeded()
        return host
    }

    private func editor(isEditable: Bool, isEnabled: Bool) -> EditorProbe {
        EditorProbe(isEditable: isEditable, isEnabled: isEnabled)
    }

    private func firstTextView(in view: NSView) -> NSTextView? {
        if let textView = view as? NSTextView { return textView }
        for subview in view.subviews {
            if let found = firstTextView(in: subview) { return found }
        }
        return nil
    }
}

private struct EditorProbe: View {
    let isEditable: Bool
    let isEnabled: Bool

    var body: some View {
        CodeEditorRepresentable(
            text: .constant("let value = 1\n"),
            language: CodeLanguageRegistry.detect(path: "Sample.swift"),
            theme: .light,
            font: .monospacedSystemFont(ofSize: 11, weight: .regular),
            isEditable: isEditable
        )
        .disabled(!isEnabled)
    }
}
#endif
