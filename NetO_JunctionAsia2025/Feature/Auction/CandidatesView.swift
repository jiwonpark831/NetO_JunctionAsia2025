//
//  CandidatesView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct CandidatesView: View {
    let biddingInfo: BiddingInfo
    let profiles: [CompanyProfile]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .foregroundColor(Color(hex: "433F3B"))
                                }
                                .padding(.horizontal, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 프로젝트 정보 카드 (항상 확장된 상태로 표시)
                    ProjectInfoCard(biddingInfo: biddingInfo)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // 회사 프로필 섹션
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Company Candidates")
                            .font(.headline)
                            .foregroundColor(Color(hex: "433F3B"))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        
                        ForEach(profiles) { profile in
                            CompanyProfileCard(profile: profile)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
    }
}
//
//#Preview {
//    CandidatesView(biddingInfo: BiddingInfo.sample)
//}
