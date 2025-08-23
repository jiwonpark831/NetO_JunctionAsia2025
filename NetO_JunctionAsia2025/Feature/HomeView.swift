//
//  HomeView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var manager = GoogleSignInManager.shared
    @State private var showingEstimation = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 사용자 정보 표시
                VStack(spacing: 10) {
                  
                    
                    Text("안녕하세요!")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("\(manager.userData.username)님")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 40)
                
                // 메인 기능 버튼들
                VStack(spacing: 20) {
                    // 견적서 버튼
                    NavigationLink(destination: EstimationView()) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .font(.title2)
                            Text("견적서 작성")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    
                    // 다른 기능 버튼들
                    HStack(spacing: 20) {

                        

                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("NetO")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    HomeView()
}
