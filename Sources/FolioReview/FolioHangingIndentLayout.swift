import SwiftUI

struct FolioHangingIndentLayout: Layout {
    static let maximumIndentFraction: CGFloat = 0.5

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard subviews.count == 2 else { return .zero }
        let indent = subviews[0].sizeThatFits(.unspecified)
        let offset = Self.contentOffset(indentWidth: indent.width, availableWidth: proposal.width)
        let content = subviews[1].sizeThatFits(Self.contentProposal(width: proposal.width, offset: offset))
        return CGSize(width: offset + content.width, height: max(indent.height, content.height))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 2 else { return }
        let indent = subviews[0].sizeThatFits(.unspecified)
        let offset = Self.contentOffset(indentWidth: indent.width, availableWidth: bounds.width)
        subviews[0].place(at: bounds.origin, proposal: ProposedViewSize(indent))
        subviews[1].place(
            at: CGPoint(x: bounds.minX + offset, y: bounds.minY),
            proposal: Self.contentProposal(width: bounds.width, offset: offset)
        )
    }

    static func contentOffset(indentWidth: CGFloat, availableWidth: CGFloat?) -> CGFloat {
        guard let availableWidth, availableWidth.isFinite else { return indentWidth }
        return min(indentWidth, max(0, availableWidth) * maximumIndentFraction)
    }

    private static func contentProposal(width: CGFloat?, offset: CGFloat) -> ProposedViewSize {
        ProposedViewSize(width: width.map { max(0, $0 - offset) }, height: nil)
    }
}
