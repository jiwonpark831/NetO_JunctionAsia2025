//
//  ProjectInfoCard.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct ProjectInfoCard: View {
    let biddingInfo: BiddingInfo
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(biddingInfo.category)
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    
                    Text(biddingInfo.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("address. \(biddingInfo.address)")
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    
                    Text("contact. \(biddingInfo.contact)")
                        .font(.caption)
                        .foregroundColor(Color(hex: "433F3B"))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Progress Status")
                            .font(.callout)
                            .foregroundColor(Color(hex: "433F3B"))
                        Text(biddingInfo.status)
                            .font(.caption)
                            .foregroundColor(Color(hex: "8F3F09"))
                    }
                    .padding(.top, 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Construction Period")
                            .font(.callout)
                            .foregroundColor(Color(hex: "433F3B"))
                        Text("start.  \(biddingInfo.startDate)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "8F3F09"))
                        Text("end.    \(biddingInfo.endDate)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "8F3F09"))
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
                
                Image(systemName: "companyimage")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color(hex: "F9F9F9"))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
