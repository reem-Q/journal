import Foundation

struct JournalEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var date: Date

    init(id: UUID = UUID(), title: String, body: String, date: Date = .now) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
    }
}
