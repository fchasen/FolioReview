# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & test

This is a SwiftPM package (Swift 5.10+, macOS 14+ / iOS 17+). There is no Xcode project committed.

```sh
swift build                                      # build all targets
swift test                                       # run all test targets
swift test --filter FolioModelTests              # single target
swift test --filter UnifiedDiffParserTests       # single test class/suite
swift test --filter UnifiedDiffParserTests/testEmptyHunk   # single XCTest case
```

`FolioModelTests` and `FolioReviewTests` use **XCTest**; `FolioHighlightTests` mixes XCTest and **Swift Testing** (`@Test` / `#expect`) — both run under `swift test`. `FolioReviewTests` does not cover `FolioView` itself (that surface is exercised by the embedding app).

If `swift test` fails with `no such module 'XCTest'`, `xcode-select` points at the Command Line Tools (which don't ship XCTest). Prefix with `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test`, or `sudo xcode-select -s /Applications/Xcode.app` to switch globally. `swift build` works on either toolchain.

## Architecture

Three libraries layer strictly upward — `FolioModel` → `FolioHighlight` → `FolioReview`. Each is a separate SwiftPM product so consumers can pull just what they need.

- **`FolioModel`** (`Sources/FolioModel/`) — Pure Swift, no SwiftUI / AppKit / UIKit. Unified-diff parsing (`UnifiedDiffParser`), `DiffHunk` / `DiffLine`, intra-line word diff (`IntralineDiff`), split-row pairing (`SplitRow` / `SplitRowBuilder`), context folding (`DiffFolder`), and multi-line `FolioLineSelection`. Anything that can be computed from text alone lives here.

- **`FolioHighlight`** (`Sources/FolioHighlight/`) — Tree-sitter syntax highlighting. `FolioHighlighter` has **two distinct modes** that share no state:
  - *Stateless:* `runs(for:language:)` parses once and returns `[Run]` — used for immutable surfaces (diff rows, snapshots).
  - *Incremental:* `reset(text:language:)` followed by `didEdit(replacedRange:replacement:in:)` retains a parser/tree/query for the highlighter's lifetime and reports only invalidated byte ranges via `Tree.edit()` + `MutableTree.changedRanges(from:)` — used for the live editor. `applyInitialAttributes` / `applyEditAttributes` (in `FolioHighlighter+Attributes.swift`) paint runs onto an `NSTextStorage`.
  - `CodeLanguage` + `CodeLanguageRegistry` map file paths to grammars via extensions. `HighlightTheme` owns all token / gutter / intra-line / comment-mark colors and ships `.light` and `.dark`.
  - Highlight queries (`.scm`) live in `Sources/FolioHighlight/Queries/` and are bundled via `resources: [.copy("Queries")]`.

- **`FolioReview`** (`Sources/FolioReview/`) — The SwiftUI entry point `FolioView`. `FolioContent` is either `.diff(DiffHunk, anchor:, mode:)` or `.code(String, startLine:)`. Read-only paths render in `Text`-backed rows (`CodeFolioRow`, `SplitFolioRow`); editable mode (only valid with `.code`) drops in a TextKit 2 `NSTextView` / `UITextView` via `Editor/CodeEditorRepresentable.swift` — `usingTextLayoutManager: true` on both platforms. Passing `editable: true` with a `.diff` content silently behaves as read-only; passing `editable: true` without a `text` binding `assertionFailure`s in debug and falls back to read-only.

### Render artifact cache

`FolioRenderArtifact` (and `FolioRenderArtifactCache`) precomputes the expensive per-hunk work — line ranges, highlight runs per line, intraline diffs by `(old, new)` text pair, split-row descriptors, folded sections — outside the SwiftUI body. When changing how diffs render, plumb new derived data through the artifact rather than recomputing inside the row views. The cache is keyed so the same hunk doesn't re-parse on every body re-eval.

## Vendored tree-sitter grammars

`Vendor/tree-sitter-<lang>/` directories hold upstream grammar sources (`src/parser.c`, sometimes `src/scanner.c`) checked into the repo. Each is declared as its own SwiftPM target in `Package.swift`:

- `exclude:` drops `grammar.js`, `src/grammar.json`, `src/node-types.json`, and `queries/` — those aren't built, and `queries/` is intentionally **not** the highlight source (the queries we use live in `Sources/FolioHighlight/Queries/` and are tuned for this project).
- `sources:` lists only the `.c` files that actually compile.
- `publicHeadersPath:` points at `bindings/swift/TreeSitter<Lang>` (a Swift-binding header dir upstream provides).
- `cSettings: [.headerSearchPath("src")]` so `parser.c` can find `tree_sitter/parser.h`.

The Markdown grammar is the exception — it comes from the `tree-sitter-grammars/tree-sitter-markdown` SwiftPM dependency, not vendored.

To regenerate after pulling upstream changes:
```sh
cd Vendor/tree-sitter-<lang>
npx tree-sitter-cli generate    # re-emits src/parser.c (and src/scanner.c if present)
```
Don't hand-edit `parser.c` / `scanner.c` — they're machine-generated.

## Conventions worth knowing

- **Platform-conditional code** uses `#if canImport(AppKit) && os(macOS)` / `#elseif canImport(UIKit)`. `PlatformColor` and `PlatformFont` are shared typealiases — prefer them over `NSColor` / `UIColor` in shared code.
- The editor data flow is one-way authoritative: the `Binding<String>` is the source of truth once the editor is mounted; external writes to the binding are mirrored into the text view, and user edits propagate back on each storage notification. When observing `NSTextStorage.didProcessEditingNotification`, gate on `editedMask.contains(.editedCharacters)` — `applyEditAttributes` itself emits attribute-only notifications and will re-enter the observer otherwise.
- License: MPL 2.0. Each vendored grammar is MIT and listed in `THIRD_PARTY_LICENSES.md`.
