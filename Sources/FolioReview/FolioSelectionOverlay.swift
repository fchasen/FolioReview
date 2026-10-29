import SwiftUI
import FolioModel

struct FolioSelectableCell: Equatable, Hashable {
    let id: String
    let line: Int
    let side: AnchorRange.Side
    let frame: CGRect
}

final class FolioSelectableCellRegistry {
    private var cellsByID: [String: FolioSelectableCell] = [:]

    var cells: [FolioSelectableCell] {
        Array(cellsByID.values)
    }

    func update(_ cell: FolioSelectableCell) {
        cellsByID[cell.id] = cell
    }

    func remove(id: String) {
        cellsByID[id] = nil
    }
}

private struct FolioSelectableCellRegistryKey: EnvironmentKey {
    static let defaultValue: FolioSelectableCellRegistry? = nil
}

extension EnvironmentValues {
    var folioSelectableCellRegistry: FolioSelectableCellRegistry? {
        get { self[FolioSelectableCellRegistryKey.self] }
        set { self[FolioSelectableCellRegistryKey.self] = newValue }
    }
}

private struct FolioCellReporter: ViewModifier {
    let id: String
    let line: Int
    let side: AnchorRange.Side
    let space: String

    @Environment(\.folioSelectableCellRegistry) private var registry

    func body(content: Content) -> some View {
        if let registry {
            if #available(macOS 15.0, iOS 18.0, *) {
                content
                    .onGeometryChange(for: CGRect.self) { proxy in
                        proxy.frame(in: .named(space))
                    } action: { frame in
                        registry.update(cell(frame: frame))
                    }
                    .onDisappear { registry.remove(id: id) }
            } else {
                content
                    .background(
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .named(space))
                            Color.clear
                                .onChange(of: frame, initial: true) { _, newFrame in
                                    registry.update(cell(frame: newFrame))
                                }
                        }
                    )
                    .onDisappear { registry.remove(id: id) }
            }
        } else {
            content
        }
    }

    private func cell(frame: CGRect) -> FolioSelectableCell {
        FolioSelectableCell(id: id, line: line, side: side, frame: frame)
    }
}

extension View {
    @ViewBuilder
    func reportingFolioCell(
        id: String,
        line: Int?,
        side: AnchorRange.Side,
        in space: String,
        enabled: Bool = true
    ) -> some View {
        if enabled, let line {
            modifier(FolioCellReporter(id: id, line: line, side: side, space: space))
        } else {
            self
        }
    }
}

extension FolioSelectionMath {
    static let coordinateSpaceName = "folio-rows"
}

enum FolioSelectionMath {
    static func cell(at point: CGPoint, in cells: [FolioSelectableCell]) -> FolioSelectableCell? {
        cells.first { $0.frame.contains(point) }
    }

    static func selection(
        from start: CGPoint,
        to current: CGPoint,
        cells: [FolioSelectableCell]
    ) -> FolioLineSelection? {
        guard let startCell = cell(at: start, in: cells) else { return nil }
        let endCell = cells
            .filter { $0.side == startCell.side }
            .min(by: { abs($0.frame.midY - current.y) < abs($1.frame.midY - current.y) })
            ?? startCell
        return FolioLineSelection(
            startLine: startCell.line,
            endLine: endCell.line,
            side: startCell.side
        )
    }
}
