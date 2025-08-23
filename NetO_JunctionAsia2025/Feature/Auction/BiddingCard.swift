//
//  BiddingCard.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//


import SwiftUI

struct BiddingCard: View {
    @State private var isExpanded: Bool = false
    let biddingInfo: BiddingInfo
    
    // 기본값을 가진 이니셜라이저
    init(biddingInfo: BiddingInfo = BiddingInfo.sample) {
        self.biddingInfo = biddingInfo
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(biddingInfo.category)
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    Text(biddingInfo.title)
                        .font(.title2)
                        .padding(.vertical, 1)
                    Text("address. \(biddingInfo.address)")
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    Text("contact. \(biddingInfo.contact)")
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    
                    // 확장 시에만 보여지는 정보
                    if isExpanded {
                        VStack(alignment: .leading) {
                            Text("Progress Status")
                                .font(.callout)
                                .foregroundColor(Color(hex: "433F3B"))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            Text(biddingInfo.status)
                                .font(.caption)
                                .foregroundColor(Color(hex: "8F3F09"))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        .padding(.vertical, 1)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Construction Period")
                                    .font(.callout)
                                    .foregroundColor(Color(hex: "433F3B"))
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                Text("start.  \(biddingInfo.startDate)")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "8F3F09"))
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                Text("end.    \(biddingInfo.endDate)")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "8F3F09"))
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            .padding(.vertical, 1)
                            Spacer()
                            
                            NavigationLink(destination: CandidatesView(biddingInfo: biddingInfo, profiles: CompanyProfile.sampleProfiles(for: .basic))) {
                                Text("View Candidates")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 11)
                                    .background(Color(hex: "FF7F17"))
                                    .cornerRadius(8)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                }
                Spacer()
               
            }
         
            // 버튼은 항상 보여짐
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "↑ Hide" : "Details")
                    .font(.caption)
                    .foregroundColor(Color(hex: "FF7F17"))
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color(hex: "F9F9F9"))
        .cornerRadius(10)
        .animation(.easeInOut, value: isExpanded)
    }
}

#Preview {
    
    BiddingCard()
}
