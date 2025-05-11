import SwiftUI

struct GameStartView: View {
    @State private var navigateToGame = false
    @State private var blink = false

    var body: some View {
        NavigationStack {
            ZStack {
                // NavigationLink yang tersembunyi
                NavigationLink(
                    destination: Level1View().navigationBarBackButtonHidden(true)
, isActive: $navigateToGame
                ) {
                    EmptyView()
                }

                // Background image full screen
                Image("level1_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                Color.black
                    .ignoresSafeArea()
                    .opacity(0.7)

                Text("Terrible Two")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .position(
                        x: UIScreen.main.bounds.midX,
                        y: UIScreen.main.bounds.midY - 150)

                Text("Tap to Play Game")
                    .font(
                        .system(size: 24, weight: .bold, design: .rounded)
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
