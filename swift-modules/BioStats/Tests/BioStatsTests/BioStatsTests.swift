import Foundation
import Testing
@testable import BioStats

@Test func subscriptGetSetAndRemove() {
    var values = AttributeValues()
    #expect(values[.strength] == nil)

    values[.strength] = 42
    #expect(values[.strength] == 42)
    #expect(values.allValues == [.strength: 42])

    values[.strength] = nil
    #expect(values[.strength] == nil)
    #expect(values.allValues.isEmpty)
}

@Test func codableRoundTrip() throws {
    var original = AttributeValues()
    original[.intelligence] = 7
    original[.strength] = 0

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AttributeValues.self, from: data)

    #expect(decoded[.intelligence] == 7)
    #expect(decoded[.strength] == 0)
    #expect(decoded[.vitality] == nil)
}
