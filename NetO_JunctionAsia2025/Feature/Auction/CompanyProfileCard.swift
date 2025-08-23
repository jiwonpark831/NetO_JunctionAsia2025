//
//  CompanyProfileCard.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct CompanyProfile: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let address: String
    let contact: String
    let rating: Int
    let Image: String
}

struct CompanyProfileCard: View {
    let profile: CompanyProfile

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(profile.category)
                    .font(.caption)
                Text(profile.name)
                    .font(.headline)
                Text(profile.address)
                    .font(.caption)
                Text(profile.contact)
                    .font(.caption)
                HStack {
                    ForEach(0..<profile.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Spacer()
            Image(profile.Image)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
        }
        .padding()
        .background(Color(hex: "F9F9F9"))
        .cornerRadius(10)
    }
}
