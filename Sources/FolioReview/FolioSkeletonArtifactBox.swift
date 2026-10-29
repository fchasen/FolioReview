import Foundation

final class FolioSkeletonArtifactBox {
    private var key: FolioRenderArtifactTaskKey.Content?
    private var contextLines: Int?
    private var cached: FolioRenderArtifact?

    func artifact(content: FolioContent, contextLines: Int) -> FolioRenderArtifact {
        let key = FolioRenderArtifactTaskKey.Content(content)
        if let cached, self.key == key, self.contextLines == contextLines {
            return cached
        }
        let built = FolioRenderArtifactBuilder.skeleton(content: content, contextLines: contextLines)
        self.key = key
        self.contextLines = contextLines
        self.cached = built
        return built
    }
}
