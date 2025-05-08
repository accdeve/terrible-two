//  StartMenu.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 08/05/25.
//

import SwiftUI

struct GameStartView: View {
    @State private var showStartText = true
    @State private var navigateToGame = false
    @State private var isShowingPopUp = false
    let blinkDuration: TimeInterval = 0.5

    var body: some View {
        NavigationStack {
            ZStack {
                // NavigationLink yang tersembunyi
                NavigationLink(
                    destination: Level1View(), isActive: $navigateToGame
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

                ZStack {
                    Image("Button_White")
                        .resizable()
                        .frame(width: 250, height: 170)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 50
                        )
                    Text("Play Game")
                        .font(
                            .system(size: 24, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.black)
                        .opacity(showStartText ? 1 : 0)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 70
                        )

                }.onTapGesture {
                    navigateToGame = true
                }

                ZStack {
                    Image("Button_White")
                        .resizable()
                        .frame(width: 250, height: 170)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 100
                        )
                    Text("Settings")
                        .font(
                            .system(size: 24, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.black)
                        .opacity(showStartText ? 1 : 0)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 120
                        )
                        .onTapGesture {
                            navigateToGame = true
                        }

                }.onTapGesture {
                    navigateToGame = true
                }

                ZStack {
                    Image("Button_White")
                        .resizable()
                        .frame(width: 250, height: 170)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 150
                        )
                    Text("Quit")
                        .font(
                            .system(size: 24, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.red)
                        .opacity(showStartText ? 1 : 0)
                        .position(
                            x: UIScreen.main.bounds.midX,
                            y: UIScreen.main.bounds.midY + 170
                        )

                }.onTapGesture {
                    isShowingPopUp = true
                }

                if isShowingPopUp {
                    VStack {
                        Text("Quit Game")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)

                        Spacer()

                        HStack {
                            Text("Quit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                                .onTapGesture {
                                    exit(0)
                                }

                            Spacer().frame(width: 10)

                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .onTapGesture {
                                    isShowingPopUp = false
                                }

                        }
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    }
                    .frame(width: 300, height: 200)  // Adjust the size for a widget-like view
                    .background()
                    .cornerRadius(12)
                    .position(
                        x: UIScreen.main.bounds.midX,
                        y: UIScreen.main.bounds.midY
                    )
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
