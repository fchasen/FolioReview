import SwiftUI
import FolioHighlight

struct FolioHighlightedText: View, Equatable {
    let text: String
    let lineRange: NSRange
    let runs: [FolioHighlighter.Run]
    let defaultColor: PlatformColor
    let backgroundRanges: [NSRange]
    let backgroundColor: PlatformColor?
    let themeSignature: Int

    var body: some View {
        let attributed = highlightedText
        let indentCount = FolioTextMetrics.leadingIndentCount(in: text)
        Group {
            if indentCount > 0, indentCount < attributed.characters.count {
                let split = attributed.characters.index(attributed.startIndex, offsetBy: indentCount)
                FolioHangingIndentLayout {
                    Text(AttributedString(attributed[..<split]))
                    Text(AttributedString(attributed[split...]))
                }
            } else {
                Text(attributed)
            }
        }
        .foregroundColor(Color(defaultColor))
    }

    static func == (lhs: FolioHighlightedText, rhs: FolioHighlightedText) -> Bool {
        lhs.text == rhs.text
            && lhs.lineRange == rhs.lineRange
            && lhs.runs == rhs.runs
            && lhs.backgroundRanges == rhs.backgroundRanges
            && lhs.themeSignature == rhs.themeSignature
            && (lhs.backgroundColor != nil) == (rhs.backgroundColor != nil)
    }

    private var highlightedText: AttributedString {
        var attr = FolioHighlighter.attributed(
            text: text,
            lineRange: lineRange,
            runs: runs,
            defaultColor: defaultColor
        )
        if let backgroundColor {
            for range in backgroundRanges {
                attr.applyBackground(on: text, range: range, color: backgroundColor)
            }
        }
        return attr
    }
}

extension View {
    @ViewBuilder
    func folioTextSelection(_ enabled: Bool) -> some View {
        if enabled {
            textSelection(.enabled)
        } else {
            self
        }
    }
}
