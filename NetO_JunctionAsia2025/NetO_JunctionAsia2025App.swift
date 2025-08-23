//
//  NetO_JunctionAsia2025App.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
}

@main
struct NetO_JunctionAsia2025App: App {

    init() {
        FirebaseApp.configure()
    }

    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
