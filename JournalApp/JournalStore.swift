import Combine
import Foundation

@MainActor
final class JournalStore: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = [] {
        didSet { save() }
    }

    private let storageKey = "journal.entries.v1"

    init() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let savedEntries = try? JSONDecoder().decode([JournalEntry].self, from: data)
        else { return }

        entries = savedEntries
    }

    func add(title: String, body: String) {
        entries.insert(JournalEntry(title: title, body: body), at: 0)
    }

    func update(_ entry: JournalEntry, title: String, body: String) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index].title = title
        entries[index].body = body
    }

    func delete(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
