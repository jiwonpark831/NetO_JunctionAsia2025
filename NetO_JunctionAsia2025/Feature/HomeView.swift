//
//  HomeView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

enum Tab {
    case bid
    case home
    case schedule
}

struct HomeView: View {
    @StateObject private var manager = GoogleSignInManager.shared
    @State private var selectedTab: Tab = .home

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Image("logo")
                HStack {
                    Text("Welcome," + "\(manager.userData.username)")
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                    }
                }
                HStack {
                    Button(action: {
                        selectedTab = .bid
                    }) {
                        Text("BID")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundStyle(
                                selectedTab == .bid ? .orange : .gray
                            )
                    }

                    Button(action: {
                        selectedTab = .home
                    }) {
                        Text("Home")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundStyle(
                                selectedTab == .home ? .orange : .gray
                            )
                    }

                    Button(action: {
                        selectedTab = .schedule
                    }) {
                        Text("SCHEDULE")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundStyle(
                                selectedTab == .schedule ? .orange : .gray
                            )
                    }
                }
                Divider()

                VStack {
                    switch selectedTab {
                    case .bid:
                        AuctionView()
                    case .home:
                        MainView()
                        NavigationLink(
                            "Make My House",
                            destination: MakeHouseView()
                        )

                    case .schedule:
                        ScheduleView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    HomeView()
}
