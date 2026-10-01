import XCTest
@testable import JournalApp

final class JournalEntryTests: XCTestCase {
    func testEntryRoundTripsThroughJSON() throws {
        let original = JournalEntry(title: "Great Day", body: "Today was memorable.")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JournalEntry.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
