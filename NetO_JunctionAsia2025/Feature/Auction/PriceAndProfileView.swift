//
//  PriceAndProfileView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct PriceAndProfileView: View {
    let category: MainCategory
    @State private var workData: [String: [WorkItem]] = [:]

    // 카테고리별 업체 프로필 더미 데이터
    var companyProfiles: [CompanyProfile] {
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
                CompanyProfile(category: "Exterior / Interior ", name: "Interior Pro", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage")
            ]
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Standard Market Unit Price")
                    .font(.headline)
                    .foregroundColor(Color(hex: "433F3B"))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                // 테이블 형태의 가격표
                ScrollView(.horizontal, showsIndicators: true) {
                    ForEach(workData.keys.sorted(), id: \.self) { section in
                        VStack(alignment: .leading, spacing: 0) {
                            // 섹션 제목
                            Text(section)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                            
                            // 테이블 컨테이너
                            VStack(spacing: 0) {
                                // 테이블 헤더
                                HStack(spacing: 0) {
                                    TableHeaderCell(text: "Code", imageName: "barcode")
                                    TableHeaderCell(text: "Name", imageName: "name")
                                    TableHeaderCell(text: "Size", imageName: "size")
                                    TableHeaderCell(text: "Unit", imageName: "unit")
                                    TableHeaderCell(text: "Unit Price", imageName: "price")
                                    TableHeaderCell(text: "Labor Ratio", imageName: "labor")
                                }
                                
                                // 테이블 데이터 행들
                                ForEach(Array((workData[section] ?? []).enumerated()), id: \.element.id) { index, item in
                                    HStack(spacing: 0) {
                                        TableDataCell(text: item.공종코드)
                                        TableDataCell(text: item.공종명칭)
                                        TableDataCell(text: item.규격)
                                        TableDataCell(text: item.단위)
                                        TableDataCell(text: "₩ \(formatNumber(item.단가))")
                                        TableDataCell(text: item.노무비율)
                                    }
                                    .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                                }
                            }
                            .overlay(
                                Rectangle()
                                    .stroke(Color(hex: "ECECEC"), lineWidth: 2)
                            )
                            .background(Color.white)
                            .cornerRadius(8)
                            .clipped()
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                // 업체 프로필 카드
                VStack(alignment: .leading, spacing: 16) {
                    Text("Standard Market Unit Price")
                        .font(.headline)
                        .foregroundColor(Color(hex: "433F3B"))
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                    
                    ForEach(companyProfiles) { profile in
                        CompanyProfileCard(profile: profile)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            loadWorkData()
        }
        .onChange(of: category) { _ in
            loadWorkData()
        }
    }
    
    // ✅ JSON 불러오기 함수
    private func loadWorkData() {
        workData = loadWorkItems(from: category.fileName)
    }
    
    // ✅ 숫자 포맷팅 함수
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// ✅ 테이블 헤더 셀 컴포넌트
struct TableHeaderCell: View {
    let text: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(imageName)
                .font(.caption)
                .foregroundColor(Color(hex: "433F3B"))
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "433F3B"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .overlay(
            Rectangle()
                .stroke(Color(hex: "ECECEC"), lineWidth: 0.5)
        )
    }
}

// ✅ 테이블 데이터 셀 컴포넌트
struct TableDataCell: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
            .overlay(
                Rectangle()
                    .stroke(Color(hex: "ECECEC"), lineWidth: 0.5)
            )
    }
}

#Preview {
    PriceAndProfileView(category: .basic)
}
