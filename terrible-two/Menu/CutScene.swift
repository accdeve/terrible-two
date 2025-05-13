//
//  CutScene.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 12/05/25.
//
import SwiftUI
import AVKit

struct CutSceneView: View {
    let videoName: String
    let fileExtension: String = "mov"
    @State private var navigateToNext = false

    var body: some View {
        ZStack {
            if let url = Bundle.main.url(forResource: videoName, withExtension: fileExtension) {
                VideoPlayer(player: AVPlayerPlayerHandler.shared.setupPlayer(url: url) {
                    // Callback ketika video selesai
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        navigateToNext = true
                    }
                })
                .ignoresSafeArea()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }

            // Navigation trigger
            NavigationLink(destination: Level1View().navigationBarBackButtonHidden(true), isActive: $navigateToNext) {
                EmptyView()
            }
        }
        .onAppear {
            AVPlayerPlayerHandler.shared.player?.play()
        }
    }
}

class AVPlayerPlayerHandler: ObservableObject {
    static let shared = AVPlayerPlayerHandler()
    var player: AVPlayer?
    private var observer: Any?

    func setupPlayer(url: URL, onFinished: @escaping () -> Void) -> AVPlayer {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Hapus observer sebelumnya (jika ada)
        if let existingObserver = observer {
            NotificationCenter.default.removeObserver(existingObserver)
        }

        // Tambah observer baru
        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            onFinished()
        }

        return player!
    }
}


#Preview {
    CutSceneView(videoName: "cutscene")
}
