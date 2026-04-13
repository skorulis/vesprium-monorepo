import Foundation
import Testing
@testable import BioStats

@Test func subscriptGetSet() {
    var values = AttributeValues()
    #expect(values[.strength] == 10)

    values[.strength] = 42
    #expect(values[.strength] == 42)
}

@Test func codableRoundTrip() throws {
    var original = AttributeValues()
    original[.cognition] = 7
    original[.strength] = 0

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AttributeValues.self, from: data)

    #expect(decoded[.cognition] == 7)
    #expect(decoded[.strength] == 0)
}
