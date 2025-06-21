import XCTest
import SwiftTreeSitter
import TreeSitterLaf

final class TreeSitterLafTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_laf())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Laf grammar")
    }
}
