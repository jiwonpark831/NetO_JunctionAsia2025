//
//  AuctionView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//  경매 페이지

import SwiftUI

struct AuctionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gavel")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("경매 서비스")
                .font(.title)
                .fontWeight(.bold)
            
            Text("건설 관련 경매 정보를 확인할 수 있습니다.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("준비 중입니다...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    AuctionView()
}
