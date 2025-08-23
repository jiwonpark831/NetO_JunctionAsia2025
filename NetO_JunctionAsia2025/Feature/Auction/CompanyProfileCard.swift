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
                    .padding(.vertical, 1)
                Text(profile.address)
                    .font(.caption)
                Text(profile.contact)
                    .font(.caption)
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(0..<profile.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        .padding(.vertical, 1)
                        
                        Button(action: {}) {
                            Text("견적서 보기")
                                .font(.caption)
                                .foregroundColor(Color(hex: "FF7F17"))
                        }
                    }
                    
                    Spacer()
                    Button(action: {}) {
                        Text("BID")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 11)
                            .background(Color(hex: "FF7F17"))
                            .cornerRadius(8)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "F9F9F9"))
        .cornerRadius(10)
    }
}

// 카테고리별 더미 데이터
extension CompanyProfile {
    static func sampleProfiles(for category: MainCategory) -> [CompanyProfile] {
        switch category {
        case .basic:
            return [
                CompanyProfile(category: "Foundation Work", name: "JA Foundation", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
                CompanyProfile(category: "Foundation Work", name: "JBaseLine Builders", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 4, Image: "companyimage"),
            ]
        case .bone:
            return [
                CompanyProfile(category: "Framing Construction", name: "JFrameWorks Ltd.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 3, Image: "companyimage"),
                CompanyProfile(category: "Framing Construction", name: "Steel & Form Co.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
            ]
        case .facility:
            return [
                CompanyProfile(category: "Facility Construction", name: "HVAC Masters", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
                CompanyProfile(category: "Facility Construction", name: "Smart Building Co.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
            ]
        case .final:
            return [
                CompanyProfile(category: "Exterior / Interior", name: "Interior Pro", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage")
            ]
        }
    }
}
