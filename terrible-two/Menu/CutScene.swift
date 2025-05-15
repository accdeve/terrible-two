import AVKit
//
//  CutScene.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 12/05/25.
//
import SwiftUI

struct CutSceneView: View {
    let videoName: String
    let fileExtension: String = "mov"
    @State private var navigateToNext = false

    var body: some View {
        ZStack {
            if let url = Bundle.main.url(
                forResource: videoName, withExtension: fileExtension)
            {
                VideoPlayerView(
                    player: AVPlayerPlayerHandler.shared.setupPlayer(url: url) {
                        DispatchQueue.main.async {
                            navigateToNext = true
                        }
                    }
                )
                .ignoresSafeArea()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }

            NavigationLink(
                destination: Level1View().navigationBarBackButtonHidden(true),
                isActive: $navigateToNext
            ) {
                EmptyView()
            }
        }
        .onAppear {
            AVPlayerPlayerHandler.shared.player?.play()
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false  // ini menyembunyikan kontrol
        // controller.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(
        _ uiViewController: AVPlayerViewController, context: Context
    ) {
        // Tidak perlu update player
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
