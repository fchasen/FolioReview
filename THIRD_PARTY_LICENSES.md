# Third-party licenses

FolioReview is licensed under the Mozilla Public License v. 2.0 (see [`LICENSE`](LICENSE)). It bundles tree-sitter grammars and binding headers from upstream authors, each retained under its original license.

## Vendored tree-sitter grammars

The `Vendor/tree-sitter-*/` directories contain pre-generated parser sources (`src/parser.c`, sometimes `src/scanner.c`) and Swift binding headers (`bindings/swift/TreeSitter<Lang>/`). Each grammar is MIT-licensed by its upstream author.

| Path | License |
|------|---------|
| `Vendor/tree-sitter-bash` | MIT — Copyright (c) 2017 Max Brunsfeld. See `Vendor/tree-sitter-bash/LICENSE`. |
| `Vendor/tree-sitter-c` | MIT, per upstream `tree-sitter/tree-sitter-c`. |
| `Vendor/tree-sitter-cpp` | MIT, per upstream `tree-sitter/tree-sitter-cpp`. |
| `Vendor/tree-sitter-css` | MIT, per upstream `tree-sitter/tree-sitter-css`. |
| `Vendor/tree-sitter-html` | MIT, per upstream `tree-sitter/tree-sitter-html`. |
| `Vendor/tree-sitter-javascript` | MIT, per upstream `tree-sitter/tree-sitter-javascript`. |
| `Vendor/tree-sitter-json` | MIT, per upstream `tree-sitter/tree-sitter-json`. |
| `Vendor/tree-sitter-python` | MIT, per upstream `tree-sitter/tree-sitter-python`. |
| `Vendor/tree-sitter-rust` | MIT, per upstream `tree-sitter/tree-sitter-rust`. |
| `Vendor/tree-sitter-swift` | MIT, per upstream. |
| `Vendor/tree-sitter-typescript` | MIT, per upstream `tree-sitter/tree-sitter-typescript`. |

When pulling a fresh copy of a grammar via `npx tree-sitter-cli generate`, re-fetch the upstream `LICENSE` alongside `src/parser.c` (and `src/scanner.c` where applicable) so the attribution stays current.

## SwiftPM dependencies

- [`tree-sitter/swift-tree-sitter`](https://github.com/tree-sitter/swift-tree-sitter) — Swift bindings to the tree-sitter runtime.
- [`tree-sitter-grammars/tree-sitter-markdown`](https://github.com/tree-sitter-grammars/tree-sitter-markdown) — Markdown grammar (MIT).

Refer to each package's own repository for the full license text.
