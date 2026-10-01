import SwiftUI

@main
struct JournalAppApp: App {
    @StateObject private var store = JournalStore()

    var body: some Scene {
        WindowGroup {
            JournalListView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
