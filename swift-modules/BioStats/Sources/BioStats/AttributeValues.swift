/// Sparse storage of numeric values keyed by ``Attribute``.
///
/// A missing key means no value is set (distinct from zero when that distinction matters).
public struct AttributeValues: Codable, Sendable, Equatable {
    private var storage: [Attribute: Int]

    public init(all: Int = Attribute.defaultValue) {
        self.storage = [:]
        for att in Attribute.allCases {
            storage[att] = all
        }
    }

    public var allValues: [Attribute: Int] {
        storage
    }

    public subscript(_ attribute: Attribute) -> Int {
        get { storage[attribute] ?? Attribute.defaultValue }
        set {
            storage[attribute] = newValue
        }
    }
}
