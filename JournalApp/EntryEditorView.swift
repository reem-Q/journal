import SwiftUI

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: JournalStore
    @FocusState private var focusedField: Field?

    let entry: JournalEntry?
    @State private var title: String
    @State private var bodyText: String

    private enum Field { case title, body }

    init(entry: JournalEntry?) {
        self.entry = entry
        _title = State(initialValue: entry?.title ?? "")
        _bodyText = State(initialValue: entry?.body ?? "")
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Title", text: $title, axis: .vertical)
                    .font(.largeTitle.bold())
                    .focused($focusedField, equals: .title)

                Text(entry?.date ?? .now, format: .dateTime.day().month().year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ZStack(alignment: .topLeading) {
                    if bodyText.isEmpty {
                        Text("Type your Journal...")
                            .foregroundStyle(.tertiary)
                            .padding(.top, 9)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $bodyText)
                        .scrollContentBackground(.hidden)
                        .focused($focusedField, equals: .body)
                        .padding(.horizontal, -5)
                }
                .font(.body)
                .padding(.top, 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .background(Color(red: 0.105, green: 0.105, blue: 0.115).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .onAppear {
                focusedField = entry == nil ? .title : .body
            }
        }
        .tint(Color(red: 0.57, green: 0.49, blue: 1.0))
        .presentationDragIndicator(.visible)
    }

    private func save() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)

        if let entry {
            store.update(entry, title: cleanTitle, body: cleanBody)
        } else {
            store.add(title: cleanTitle, body: cleanBody)
        }
        dismiss()
    }
}
