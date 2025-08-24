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
    var username: String = ""
    var email: String = ""
}

class GoogleSignInManager: ObservableObject {
    static let shared = GoogleSignInManager()

    @Published var userData = UserData()
    @Published var isLogin = false
    @Published var showOnboarding: Bool = true

    private init() {
        checkLoginStatus()
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
        ) { result, error in

            if let error = error {
                print("Google 로그인 실패: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                print("Error: Google 사용자 정보 또는 ID Token을 가져올 수 없습니다.")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in

                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                    return
                }

                guard let firebaseUser = authResult?.user else {
                    print("Error: Firebase 사용자 정보를 가져올 수 없습니다.")
                    return
                }

                print("Firebase 로그인 성공! UID: \(firebaseUser.uid)")

                DispatchQueue.main.async {
                    self.userData.userId = firebaseUser.uid
                    self.userData.idToken = idToken
                    self.userData.email = firebaseUser.email ?? ""
                    self.userData.username = firebaseUser.displayName ?? ""

                    self.isLogin = true
                    self.showOnboarding = false
                }
            }
        }
    }
    
    private func checkLoginStatus() {
        if let currentUser = Auth.auth().currentUser {
            // 이미 로그인된 사용자가 있음
            self.userData.userId = currentUser.uid
            self.userData.email = currentUser.email ?? ""
            self.userData.username = currentUser.displayName ?? ""
            self.isLogin = true
            self.showOnboarding = false
        } else {
            // 로그인된 사용자가 없음
            self.isLogin = false
            self.showOnboarding = false
        }
    }
}
