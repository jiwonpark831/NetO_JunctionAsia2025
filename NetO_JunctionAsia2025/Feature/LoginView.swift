//
//  LoginView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var manager = GoogleSignInManager()

    var body: some View {
        VStack {
            if manager.isLogin {
                HomeView()
            } else {
                Button(action: {
                    manager.signIn()
                }) {
                    Text("Log in with Google account")
                        .background(.white)
                        .foregroundColor(.orange)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
