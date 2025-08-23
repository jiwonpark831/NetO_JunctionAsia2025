//
//  TableComponents.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

// 테이블 헤더 셀 컴포넌트
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

// 테이블 데이터 셀 컴포넌트
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
