//
//  terrible_twoApp.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 04/05/25.
//

import SwiftUI

@main
struct terrible_twoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Level12View()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .landscape
    }
}
