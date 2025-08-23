//
//  ContentView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 견적 계산 탭
            EstimationView()
                .tabItem {
                    Image(systemName: "calculator")
                    Text("견적 계산")
                }
                .tag(0)
            
            // 기존 기능들
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(1)
            

            

            
            AuctionView()
                .tabItem {
                    Image(systemName: "gavel")
                    Text("경매")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
