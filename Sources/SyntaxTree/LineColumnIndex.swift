import Foundation

public struct LineColumnIndex {
    private let charactersPerLine: [Range<Int>]
    private let lines: [String]

    public init(string: String) {
        lines = string.components(separatedBy: "\n")
        charactersPerLine = lines.collect(0..<0) { $0.upperBound..<($0.upperBound + $1.count + 1) }
    }

    public subscript(line: Int, column: Int) -> Int {
        return charactersPerLine[line].lowerBound + column
    }

    public subscript(offset: Int) -> Location? {
        guard let (lineIndex, line) = charactersPerLine.enumerated().first(where: { $0.element.contains(offset) }) else {
            return nil
        }
        return Location(line: lineIndex, column: offset - line.lowerBound)
    }
}

extension LineColumnIndex {

    public subscript(location: Location) -> Int {
        return self[location.line, location.column]
    }

}

extension Sequence {

    fileprivate func collect<Value>(_ initialValue: Value, transform: (Value, Element) throws -> Value) rethrows -> [Value] {
        var collected = [Value]()
        for element in self {
            collected.append(try transform(collected.last ?? initialValue, element))
        }
        return collected
    }

}
