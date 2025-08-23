//
//  PriceTableView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct PriceTableView: View {
    let workData: [String: [WorkItem]]
    
    var body: some View {
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
    }
    
    // 숫자 포맷팅 함수
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}
