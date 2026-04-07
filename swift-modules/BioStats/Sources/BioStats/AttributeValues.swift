/// Sparse storage of numeric values keyed by ``Attribute``.
///
/// A missing key means no value is set (distinct from zero when that distinction matters).
public struct AttributeValues: Codable, Sendable, Equatable {
    private var storage: [Attribute: Int]

    public init(values: [Attribute: Int] = [:]) {
        self.storage = values
    }
    
    public init(all: Int) {
        self.storage = [:]
        for att in Attribute.allCases {
            storage[att] = all
        }
    }

    public var allValues: [Attribute: Int] {
        storage
    }

    public subscript(_ attribute: Attribute) -> Int? {
        get { storage[attribute] }
        set {
            if let newValue {
                storage[attribute] = newValue
            } else {
                storage.removeValue(forKey: attribute)
            }
        }
    }
}
