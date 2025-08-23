//
//  HomeView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var manager = GoogleSignInManager.shared

    var body: some View {
        Text("HomeView")
        Text("\(manager.userData.username)")
    }
}

#Preview {
    HomeView()
}
