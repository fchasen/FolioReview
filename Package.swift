// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FolioReview",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "FolioReview", targets: ["FolioReview"]),
        .library(name: "FolioModel", targets: ["FolioModel"]),
        .library(name: "FolioHighlight", targets: ["FolioHighlight"]),
        .library(name: "TreeSitterSwift", targets: ["TreeSitterSwift"]),
        .library(name: "TreeSitterTypeScript", targets: ["TreeSitterTypeScript"]),
        .library(name: "TreeSitterJavaScript", targets: ["TreeSitterJavaScript"]),
        .library(name: "TreeSitterPython", targets: ["TreeSitterPython"]),
        .library(name: "TreeSitterRust", targets: ["TreeSitterRust"]),
        .library(name: "TreeSitterGo", targets: ["TreeSitterGo"]),
        .library(name: "TreeSitterC", targets: ["TreeSitterC"]),
        .library(name: "TreeSitterCPP", targets: ["TreeSitterCPP"]),
        .library(name: "TreeSitterRuby", targets: ["TreeSitterRuby"]),
        .library(name: "TreeSitterBash", targets: ["TreeSitterBash"])
    ],
    dependencies: [
        .package(url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.10.0"),
        .package(url: "https://github.com/tree-sitter-grammars/tree-sitter-markdown", from: "0.5.3")
    ],
    targets: [
        .target(name: "FolioModel"),

        .target(
            name: "TreeSitterJavaScript",
            path: "Vendor/tree-sitter-javascript",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterJavaScript",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterTypeScript",
            path: "Vendor/tree-sitter-typescript",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterTypeScript",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterPython",
            path: "Vendor/tree-sitter-python",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterPython",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterRust",
            path: "Vendor/tree-sitter-rust",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterRust",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterGo",
            path: "Vendor/tree-sitter-go",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries",
                "LICENSE"
            ],
            sources: ["src/parser.c"],
            publicHeadersPath: "bindings/swift/TreeSitterGo",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterRuby",
            path: "Vendor/tree-sitter-ruby",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries",
                "LICENSE"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterRuby",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterC",
            path: "Vendor/tree-sitter-c",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c"],
            publicHeadersPath: "bindings/swift/TreeSitterC",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterCPP",
            path: "Vendor/tree-sitter-cpp",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterCPP",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterJSON",
            path: "Vendor/tree-sitter-json",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c"],
            publicHeadersPath: "bindings/swift/TreeSitterJSON",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterHTML",
            path: "Vendor/tree-sitter-html",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterHTML",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterCSS",
            path: "Vendor/tree-sitter-css",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterCSS",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterSwift",
            path: "Vendor/tree-sitter-swift",
            exclude: [
                "grammar.js",
                "src/grammar.json",
                "src/node-types.json",
                "queries"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterSwift",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "TreeSitterBash",
            path: "Vendor/tree-sitter-bash",
            exclude: [
                "src/grammar.json",
                "src/node-types.json",
                "queries",
                "LICENSE"
            ],
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "bindings/swift/TreeSitterBash",
            cSettings: [.headerSearchPath("src")]
        ),
        .target(
            name: "FolioHighlight",
            dependencies: [
                .product(name: "SwiftTreeSitter", package: "swift-tree-sitter"),
                .product(name: "TreeSitterMarkdown", package: "tree-sitter-markdown"),
                "TreeSitterJavaScript",
                "TreeSitterTypeScript",
                "TreeSitterPython",
                "TreeSitterRust",
                "TreeSitterC",
                "TreeSitterCPP",
                "TreeSitterJSON",
                "TreeSitterHTML",
                "TreeSitterCSS",
                "TreeSitterSwift",
                "TreeSitterBash"
            ],
            resources: [.copy("Queries")]
        ),
        .target(
            name: "FolioReview",
            dependencies: ["FolioModel", "FolioHighlight"]
        ),
        .testTarget(
            name: "FolioModelTests",
            dependencies: ["FolioModel"]
        ),
        .testTarget(
            name: "FolioHighlightTests",
            dependencies: ["FolioHighlight"]
        ),
        .testTarget(
            name: "FolioReviewTests",
            dependencies: ["FolioReview"]
        )
    ]
)
