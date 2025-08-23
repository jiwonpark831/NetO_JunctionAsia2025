//
//  GoogleSignInManager.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

struct UserData {
    var userId: String = ""
    var idToken: String = ""
}

class GoogleSignInManager: ObservableObject {
    @Published var userData = UserData()
    @Published var username: String?
    @Published var isLogin = false

    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            self.username = user.profile?.givenName ?? ""
            userData.userId = user.userID ?? ""
            userData.idToken = user.idToken?.tokenString ?? ""
            isLogin = true
        }
    }

    func signIn() {
        guard
            let presentingViewController =
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController
        else {
            return
        }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { _, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }

            self.checkUserInfo()
        }
    }
}
