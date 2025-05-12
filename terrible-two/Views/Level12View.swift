//
//  Level12View.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//

import SpriteKit
import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    var player: AVAudioPlayer?

    @Published var volume: Float {
        didSet {
            player?.volume = volume
            UserDefaults.standard.set(volume, forKey: "bgVolume")
        }
    }
    
    @Published var isMuted: Bool = true {
            didSet {
                player?.volume = isMuted ? 0 : volume
            }
    }

    init() {
        let savedVolume = UserDefaults.standard.float(forKey: "bgVolume")
        self.volume = savedVolume == 0 ? 0.5 : savedVolume
        if let url = Bundle.main.url(forResource: "no-copyright-music-corporate-background-334863", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = 0
//                player?.volume = volume yang asli ini ygy
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                print("Error loading audio: \(error)")
            }
        }
    }
}

struct Level12View: View {
    @StateObject var audioManager = AudioManager()
    @State private var showingSettings = false
    @State private var fadeIn = true
    
    var scene: SKScene {
        let scene = Level1Stage2Scene()
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            // Lapisan hitam untuk fade-in
            
            if showingSettings {
                GameSettingsView(audioManager: audioManager)
            }
            
            Color.black
                .ignoresSafeArea()
                .opacity(fadeIn ? 1 : 0)
                .animation(.easeOut(duration: 1.5), value: fadeIn)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingSettings = !showingSettings
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .padding(.trailing, -45)
                            .padding(.top, 10)
                    }
                }
                Spacer()
            }
            
            if showingSettings {
                GameSettingsView(audioManager: audioManager)
            }

        }
        .onAppear {
            // Trigger fade-in
            fadeIn = false
        }
//
    }
}


#Preview {
    Level12View()
}
