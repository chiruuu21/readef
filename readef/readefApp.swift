//
//  readefApp.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import FirebaseCore

// 1. We renamed this class to 'FirebaseAppDelegate' to avoid conflicts
class FirebaseAppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct readefApp: App {
    // 2. Connect the RENAMED Delegate to the App
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
