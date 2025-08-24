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
    @State private var showMakeHouseView = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {

                Image("archlogo").padding(20)

                HStack {
                    VStack {
                        Text("Welcome, \(manager.userData.username)").font(
                            .system(size: 16, weight: .bold)
                        )
                    }.padding(.leading, 20)
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "bell.fill").foregroundStyle(.black)
                            .font(.system(size: 20))
                    }.padding(.trailing, 20)
                }

                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white, .jayellow,
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ).frame(height: 70)
                    HStack {
                        Button(action: {
                            selectedTab = .bid
                        }) {
                            Text("BID")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(
                                    selectedTab == .bid ? .jaorange : .gray
                                )
                        }

                        Button(action: {
                            selectedTab = .home
                        }) {
                            Text("Home")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(
                                    selectedTab == .home ? .jaorange : .gray
                                )
                        }

                        Button(action: {
                            selectedTab = .schedule
                        }) {
                            Text("SCHEDULE")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(
                                    selectedTab == .schedule ? .jaorange : .gray
                                )
                        }
                    }
                }

                VStack {
                    switch selectedTab {
                    case .bid:
                        AuctionView()
                    case .home:
                        MainView()
                        Spacer().frame(height: 70)
                        NavigationLink(
                            destination: MakeHouseView(
                                isPresented: $showMakeHouseView
                            ),  // Binding 전달
                            isActive: $showMakeHouseView
                        ) {
                            Text("LET’S GET PLANNED")
                            // ... (버튼 스타일은 그대로) ...
                        }.frame(maxWidth: 200)
                            .padding(.vertical, 14)
                            .fontWeight(.black)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                .jaorange, .jayellow,
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
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
