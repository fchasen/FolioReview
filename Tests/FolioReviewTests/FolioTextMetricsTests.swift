import XCTest
@testable import FolioReview

final class FolioTextMetricsTests: XCTestCase {
    func testEmptyTextHasOneLine() {
        XCTAssertEqual(FolioTextMetrics.lineCount(in: ""), 1)
    }

    func testSingleLineTextHasOneLine() {
        XCTAssertEqual(FolioTextMetrics.lineCount(in: "let value = 1;"), 1)
    }

    func testMultilineTextCountsNewlines() {
        XCTAssertEqual(FolioTextMetrics.lineCount(in: "a\nb\nc"), 3)
    }

    func testTrailingNewlineCountsEmptyFinalLine() {
        XCTAssertEqual(FolioTextMetrics.lineCount(in: "a\n"), 2)
    }

    func testLeadingIndentCountsSpacesAndTabs() {
        XCTAssertEqual(FolioTextMetrics.leadingIndentCount(in: "  \t  this.call();"), 5)
    }

    func testLeadingIndentIsZeroForUnindentedText() {
        XCTAssertEqual(FolioTextMetrics.leadingIndentCount(in: "let value = 1;"), 0)
    }

    func testLeadingIndentCoversWhitespaceOnlyText() {
        XCTAssertEqual(FolioTextMetrics.leadingIndentCount(in: "    "), 4)
    }

    func testHangingIndentKeepsIndentWhenItFits() {
        XCTAssertEqual(FolioHangingIndentLayout.contentOffset(indentWidth: 80, availableWidth: 400), 80)
    }

    func testHangingIndentIsCappedAtHalfTheWidth() {
        XCTAssertEqual(FolioHangingIndentLayout.contentOffset(indentWidth: 300, availableWidth: 400), 200)
    }

    func testHangingIndentUsesIdealWidthWithoutAProposal() {
        XCTAssertEqual(FolioHangingIndentLayout.contentOffset(indentWidth: 80, availableWidth: nil), 80)
        XCTAssertEqual(FolioHangingIndentLayout.contentOffset(indentWidth: 80, availableWidth: .infinity), 80)
    }
}
