
import Foundation

public protocol SyntaxTreeFactory {
    func parse(_ text: String) throws -> SyntaxTree
}
