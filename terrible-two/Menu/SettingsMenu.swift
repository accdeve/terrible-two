//
//  SettingsMenu.swift
//  terrible-two
//
//  Created by steven on 08/05/25.
//

import SwiftUI

import SwiftUI

struct GameSettingsView: View {
    @State private var dragOffsetVolume: CGFloat = 0
    @State private var dragOffsetSound: CGFloat = 0
    @State private var isChecked = false
    let sliderWidth: CGFloat = 300
    
    var body: some View {
        VStack{
            ZStack {
                Image("Latar_Popup")
                    .resizable()
                    .frame(width: 500, height: 400)
                VStack{
                    VStack(spacing: 10) {
                        Text("Volume")
                            .font(.headline)
                        CustomSlider(dragOffset: $dragOffsetVolume, sliderWidth: sliderWidth)
                    }
                    VStack(spacing: 10) {
                        Text("Sound FX")
                            .font(.headline)
                        CustomSlider(dragOffset: $dragOffsetSound, sliderWidth: sliderWidth)
                    }
                    HStack{
                        Spacer()
                        Text("Mute")
                        Spacer()
                        Button(action: {
                            isChecked.toggle()
                        }) {
                            Image(isChecked ? "Settings_Check" : "Settings_Uncheck")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        Spacer()
                        
                    }
                    ZStack{
                        Image("Image")
                            .resizable()
                            .frame(width: 100, height: 150)
                            .position(x: 155, y: 25)
                        Text("Back")
                            .font(.caption)
                            .foregroundColor(.white)
                            .position(x: 155, y: 25)
                    }.frame(width: 300, height: 300)
                        //.background(.blue)
                    
                }.position(x: 250, y: 325)
            }.frame(maxHeight: .infinity)
        }.position(x: 175, y: 150)
            .frame(width: 400, height: 300)
        
    }
}

struct CustomSlider: View {
    @Binding var dragOffset: CGFloat
    let sliderWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Image("Settings_Slider_Bar")
                    .resizable()
                    .frame(width: sliderWidth)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)

                Image("Settings_Slider_Icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .position(
                        x: geo.size.width / 2 + dragOffset,
                        y: geo.size.height / 2
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let localX = value.location.x - geo.size.width / 2
                                let halfWidth = sliderWidth / 2
                                dragOffset = min(max(localX, -halfWidth), halfWidth)
                            }
                    )
            }
        }
        .frame(height: 60)
    }
}

#Preview {
    GameSettingsView()
}
