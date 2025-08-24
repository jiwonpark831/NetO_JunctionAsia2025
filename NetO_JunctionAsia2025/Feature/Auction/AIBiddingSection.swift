//
//  AIBiddingSection.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct AIBiddingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Generated Bidding")
                .font(.headline)
                .foregroundColor(Color(hex: "433F3B"))
                .fontWeight(.bold)
                .padding(.vertical, 10)
            
            BiddingCard()
        }
    }
}

#Preview {
    AIBiddingSection()
}
