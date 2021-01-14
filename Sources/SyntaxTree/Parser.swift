
import Foundation

public protocol Parser {
    func parse(_ text: String) throws -> SyntaxTree
}
