/// Sparse storage of numeric values keyed by ``Attribute``.
///
/// A missing key means no value is set (distinct from zero when that distinction matters).
public struct AttributeValues: Codable, Sendable, Equatable {
    private var storage: [Attribute: Double]

    public init(values: [Attribute: Double] = [:]) {
        self.storage = values
    }

    public var allValues: [Attribute: Double] {
        storage
    }

    public subscript(_ attribute: Attribute) -> Double? {
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
