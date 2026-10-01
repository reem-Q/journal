import SwiftUI

struct JournalListView: View {
    @EnvironmentObject private var store: JournalStore
    @State private var editor: EditorRoute?

    var body: some View {
        NavigationStack {
            Group {
                if store.entries.isEmpty {
                    EmptyJournalView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.entries) { entry in
                                JournalCard(
                                    entry: entry,
                                    onEdit: { editor = .edit(entry) },
                                    onDelete: { store.delete(entry) }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { editor = .new } label: {
                        Image(systemName: "plus")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color.accentPurple)
                    }
                    .accessibilityLabel("New journal entry")
                }
            }
            .sheet(item: $editor) { route in
                EntryEditorView(entry: route.entry)
                    .environmentObject(store)
            }
        }
        .tint(.accentPurple)
    }
}

private enum EditorRoute: Identifiable {
    case new
    case edit(JournalEntry)

    var id: UUID {
        switch self {
        case .new: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        case .edit(let entry): entry.id
        }
    }

    var entry: JournalEntry? {
        guard case .edit(let entry) = self else { return nil }
        return entry
    }
}

private struct EmptyJournalView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 104, height: 65)
                    .rotationEffect(.degrees(-14))
                    .overlay {
                        Image(systemName: "scribble.variable")
                            .font(.title)
                            .foregroundStyle(.black)
                            .rotationEffect(.degrees(-14))
                    }

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.91, green: 0.72, blue: 1.0))
                    .frame(width: 76, height: 58)
                    .rotationEffect(.degrees(13))
                    .offset(x: 34, y: 25)
                    .overlay {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(.purple)
                            .rotationEffect(.degrees(13))
                            .offset(x: 34, y: 25)
                    }
            }
            .frame(height: 125)

            Text("Begin Your Journal")
                .font(.title3.bold())
                .padding(.top, 24)

            Text("Craft your personal diary, tap the\nplus icon to begin")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 14)

            Spacer()
                .frame(height: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct JournalCard: View {
    let entry: JournalEntry
    let onEdit: () -> Void
    let onDelete: () -> Void

    private var displayTitle: String {
        entry.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Untitled"
            : entry.title
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(displayTitle)
                    .font(.title3.bold())
                    .foregroundStyle(Color.accentPurple)
                    .lineLimit(1)

                Spacer()

                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.accentPurple)
                        .frame(width: 28, height: 28)
                        .background(Color.white.opacity(0.08), in: Circle())
                }
            }

            Text(entry.date, format: .dateTime.day().month().year())
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(entry.body)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}

private extension Color {
    static let accentPurple = Color(red: 0.57, green: 0.49, blue: 1.0)
    static let cardBackground = Color(red: 0.105, green: 0.105, blue: 0.115)
}

#Preview("Empty") {
    JournalListView()
        .environmentObject(JournalStore())
        .preferredColorScheme(.dark)
}
