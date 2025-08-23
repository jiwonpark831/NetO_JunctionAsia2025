//
//  LoginView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var manager = GoogleSignInManager.shared

    var body: some View {
        VStack {
            if manager.isLogin {
                if manager.showOnboarding {
                    OnboardingView()
                } else {
                    HomeView()
                }
            } else {
                Spacer().frame(height: 100)
                Image("biglogo")
                Spacer().frame(height: 50)
                Text("where construction connects")
                Spacer().frame(height: 40)
                Text("arch").font(Font.largeTitle)
                Spacer().frame(height: 80)
                Button(action: {
                    manager.signIn()
                }) {
                    Text("Log in with Google account").fontWeight(.bold)

                }
                .padding(15)
                .background(.white)
                .foregroundColor(.jaorange)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.jaorange, lineWidth: 1)
                )
                Image("building").frame(
                    maxHeight: .infinity,
                    alignment: .bottom
                )
            }
        }.ignoresSafeArea(edges: .bottom)

    }
}

#Preview {
    LoginView()
}
