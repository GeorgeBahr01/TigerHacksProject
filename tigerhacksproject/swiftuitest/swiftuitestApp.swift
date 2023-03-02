//
//  swiftuitestApp.swift
//  swiftuitest
//
//  Created by Andy on 11/5/22.
//

import SwiftUI

@main
struct swiftuitestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
