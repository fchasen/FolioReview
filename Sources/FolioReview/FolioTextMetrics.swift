enum FolioTextMetrics {
    static func lineCount(in text: String) -> Int {
        var count = 1
        for unit in text.utf8 where unit == 0x0A {
            count += 1
        }
        return count
    }

    static func leadingIndentCount(in text: String) -> Int {
        var count = 0
        for character in text {
            guard character == " " || character == "\t" else { return count }
            count += 1
        }
        return count
    }
}
