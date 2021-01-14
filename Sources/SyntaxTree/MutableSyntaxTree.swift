
import Foundation

public class MutableSyntaxTree {
    public var kind: Kind?
    public var range: Range<Int>
    public var location: Range<Location>
    public var annotations: [String : Encodable]
    public var children: [MutableSyntaxTree]

    public init(kind: Kind? = nil,
                range: Range<Int>,
                location: Range<Location>,
                annotations: [String : Encodable],
                children: [MutableSyntaxTree]) {

        self.kind = kind
        self.range = range
        self.location = location
        self.annotations = annotations
        self.children = children
    }

    public func add(annotations: [String : Encodable]) {
        self.annotations.merge(annotations.mapValues(AnyEncodable.init)) { $1 }
    }
}

extension MutableSyntaxTree {

    public func build() -> SyntaxTree {
        return SyntaxTree(kind: kind,
                          range: range,
                          location: location,
                          annotations: annotations,
                          children: children.map { $0.build() })
    }

}

extension MutableSyntaxTree {

    public func prune(using strategy: Kind.CombinationStrategy) {
        children = children.filter { $0.kind != nil || !$0.annotations.isEmpty || !$0.range.isEmpty }

        if children.count == 1 {
            prune(using: children[0], and: strategy)
        }

        for child in self.children {
            child.prune(using: .separate)
        }
    }

    fileprivate func prune(using child: MutableSyntaxTree, and strategy: Kind.CombinationStrategy) {
        var newKind: Kind? = kind ?? child.kind
        if let kind = kind, let otherKind = child.kind {
            switch strategy {
            case .separate:
                return child.prune(using: .separate)
            case .higher:
                newKind = kind
            case .lower:
                newKind = otherKind
            }
        }

        guard range == child.range, Set(child.annotations.keys).intersection(annotations.keys).isEmpty else {
            return child.prune(using: .separate)
        }

        kind = newKind
        children = child.children
        annotations.merge(child.annotations) { $1 }
        prune(using: strategy)
    }

}
private struct AnyEncodable: Encodable {
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
