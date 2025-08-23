//
//  NetO_JunctionAsia2025App.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import Firebase
import SwiftUI

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct NetOApp: App {

    init() {
        FirebaseApp.configure()
    }

    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
