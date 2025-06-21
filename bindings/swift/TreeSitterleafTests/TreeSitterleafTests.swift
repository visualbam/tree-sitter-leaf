import XCTest
import SwiftTreeSitter
import TreeSitterLeaf

final class TreeSitterLeafTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_leaf())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading leaf grammar")
    }
}
