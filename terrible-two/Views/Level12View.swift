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
        if let url = Bundle.main.url(forResource: "backsound", withExtension: "m4a") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = volume 
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
                        Image("Setting_Icon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .padding(.trailing, -45)
                            .padding(.top, 10)
                    }
                } .
                sheet(isPresented: $showingSettings) {
                    GameSettingsView(audioManager: audioManager)
                }
                Spacer()
            }

        }
        .onAppear {
            fadeIn = false
        }
//
    }
}


#Preview {
    Level12View()
}
