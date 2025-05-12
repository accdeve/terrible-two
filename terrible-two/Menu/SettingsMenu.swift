//
//  SettingsMenu.swift
//  terrible-two
//
//  Created by steven on 08/05/25.
//

import SwiftUI
import AVFoundation

struct GameSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isChecked = false
    @State private var isClicked = false
    
    @StateObject var audioManager = AudioManager()
    
    var body: some View {
        VStack{
            ZStack {
                Image("Latar_Popup")
                    .resizable()
                    .frame(width: 500, height: 400)
                VStack (spacing: 20){
                    Text("Settings")
                        .font(.custom("Chalkduster", size: 32))
                    VStack(spacing: 20) {
                        Text("Volume")
                            .font(.custom("Chalkduster", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        HStack {
                            CustomSlider(
                                value: Binding<Float>(
                                    get: {
                                        audioManager.isMuted ? 0 : audioManager.volume
                                    },
                                    set: { newVal in
                                        audioManager.isMuted = false
                                        audioManager.volume = newVal
                                    }
                                ),
                                minValue: 0,
                                maxValue: 1
                            )
                                .frame(height: 30)
                        }
                        .padding(.horizontal)
                    }
                    //Spacer()
                    HStack{
                        //Spacer()
                        Text("Mute")
                            .font(.custom("Chalkduster", size: 24))
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            audioManager.isMuted.toggle()
                        }) {
                            Image(audioManager.isMuted ? "Settings_Check" : "Settings_Uncheck")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }.padding(.trailing, 20)
                        //Spacer()
                        
                    }
                    Button(action: {
                        dismiss()
                    }) {
                        Image("Back_Button")
                            .resizable()
                            .frame(width: 150, height: 100)
                            .padding(.vertical, -15)
                    }
                }
                //.background(Color.green)
                    .frame(width: 400, height: 100)
            }
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Float
    let minValue: Float
    let maxValue: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track image
                Image("Settings_Slider_Bar")
                    .resizable()

                // Filled track
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: CGFloat(value / (maxValue - minValue)) * geometry.size.width, height: 8)
                    .cornerRadius(4)

                // Thumb
                Image("Settings_Slider_Icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .offset(x: CGFloat(value / (maxValue - minValue)) * geometry.size.width - 12)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            let newValue = min(max(0, gesture.location.x / geometry.size.width), 1)
                            self.value = minValue + Float(newValue) * (maxValue - minValue)
                        }
                    )
            }
        }
        .frame(height: 30)
    }
}

//class AudioManager: ObservableObject {
//    var player: AVAudioPlayer?
//
//    @Published var volume: Float {
//        didSet {
//            player?.volume = volume
//            UserDefaults.standard.set(volume, forKey: "bgVolume")
//        }
//    }
//    
//    @Published var isMuted: Bool = false {
//            didSet {
//                player?.volume = isMuted ? 0 : volume
//            }
//        }
//
//    init() {
//        let savedVolume = UserDefaults.standard.float(forKey: "bgVolume")
//        self.volume = savedVolume == 0 ? 0.5 : savedVolume
//        if let url = Bundle.main.url(forResource: "no-copyright-music-corporate-background-334863", withExtension: "mp3") {
//            do {
//                player = try AVAudioPlayer(contentsOf: url)
//                player?.volume = volume
//                player?.numberOfLoops = -1
//                player?.play()
//            } catch {
//                print("Error loading audio: \(error)")
//            }
//        }
//    }
//}

#Preview {
    GameSettingsView()
}
