//  StartMenu.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 08/05/25.
//
import SwiftUI

struct GameStartView: View {
    @State private var navigateToGame = false
    @State private var blink = false

    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(
                    destination: CutSceneView(videoName: "cutscene").navigationBarBackButtonHidden(true), isActive: $navigateToGame
                ) {
                    EmptyView()
                }

                // Background image full screen
                Image("menu_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                Color.black
                    .ignoresSafeArea()
                    .opacity(0.7)

                Text("Terrible Two")
                    .font(.custom("Chalkduster", size: 52))
                    .foregroundColor(.white)
                    .position(
                        x: UIScreen.main.bounds.midX,
                        y: UIScreen.main.bounds.midY - 130)

                Text("Press here to start")
                    .font(
                        .custom("Chalkduster", size: 24)
                    )
                    .foregroundColor(.white)
                    .opacity(blink ? 1 : 0) // Ganti ini
                    .position(
                        x: UIScreen.main.bounds.midX,
                        y: UIScreen.main.bounds.midY + 170
                    )
                    .onTapGesture {
                        navigateToGame = true
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            blink.toggle()
                        }
                    }
            }
        }
    }
}

struct GameView: View {
    var body: some View {
        Text("Game View")
            .font(.largeTitle)
            .foregroundColor(.black)
    }
}

#Preview {
    GameStartView()
}
