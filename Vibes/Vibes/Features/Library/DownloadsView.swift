import SwiftUI

struct DownloadsView: View {
    @ObservedObject private var downloads = DownloadManager.shared
    @State private var songIDs: [String] = []

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Storage used")
                    Spacer()
                    Text(downloads.formattedDownloadSize)
                        .foregroundColor(.secondary)
                }
            }
            Section("Downloaded Songs") {
                if songIDs.isEmpty {
                    ContentUnavailableView(
                        "No Downloads",
                        systemImage: "arrow.down.circle",
                        description: Text("Songs you download will appear here.")
                    )
                } else {
                    ForEach(songIDs, id: \.self) { id in
                        Label(id, systemImage: "music.note")
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            downloads.deleteDownload(songId: songIDs[index])
                        }
                        refresh()
                    }
                }
            }
        }
        .navigationTitle("Downloads")
        .onAppear(perform: refresh)
        .onReceive(downloads.$activeDownloads) { _ in refresh() }
    }

    private func refresh() {
        songIDs = downloads.getDownloadedSongIds().sorted()
    }
}
