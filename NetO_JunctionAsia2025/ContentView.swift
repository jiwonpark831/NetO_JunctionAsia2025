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
            
            // 표준단가 브라우저 탭
            StandardPriceView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("표준단가")
                }
                .tag(1)
            
            // 견적 히스토리 탭
            EstimationHistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("견적 히스토리")
                }
                .tag(2)
            
            // 기존 기능들
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(3)
            
            MakeHouseView()
                .tabItem {
                    Image(systemName: "hammer")
                    Text("집짓기")
                }
                .tag(4)
            
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("일정")
                }
                .tag(5)
            
            AuctionView()
                .tabItem {
                    Image(systemName: "gavel")
                    Text("경매")
                }
                .tag(6)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
