//
//  GameState.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 12/05/25.
//

import Combine
import Foundation

class GameState: ObservableObject {
    @Published var isFinish: Bool = false
    @Published var isDadIsComingActive: Bool = false
}
