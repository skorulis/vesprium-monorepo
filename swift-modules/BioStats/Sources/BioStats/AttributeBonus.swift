//  Created by Alexander Skorulis on 7/4/2026.

import Foundation

public struct AttributeBonus {
    public let attribute: Attribute
    public let value: Int

    public init(attribute: Attribute, value: Int) {
        self.attribute = attribute
        self.value = value
    }
}
