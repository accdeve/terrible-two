//
//  StartMenu.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 08/05/25.
//
import SwiftUI

struct GameStartView: View {
    @State private var showStartText = true
    let blinkDuration: TimeInterval = 0.5

    var body: some View {
        ZStack {
            // Background image full screen
            Image("level1_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black
                .ignoresSafeArea()
                .opacity(0.7)

            Text("Terrible Two")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .position(
                    x: UIScreen.main.bounds.midX,
                    y: UIScreen.main.bounds.midY - 150)

            Text("Start Game")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.yellow)
                .opacity(showStartText ? 1 : 0)
                .position(
                    x: UIScreen.main.bounds.midX,
                    y: UIScreen.main.bounds.midY + 150
                )
                .animation(.easeInOut(duration: 0.5), value: showStartText)

        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: blinkDuration, repeats: true)
            { _ in
                withAnimation {
                    showStartText.toggle()
                }
            }
        }
    }
}

#Preview {
    GameStartView()
}
