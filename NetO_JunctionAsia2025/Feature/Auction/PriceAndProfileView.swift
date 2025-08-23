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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Standard Market Unit Price")
                    .font(.headline)
                    .foregroundColor(Color(hex: "433F3B"))
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                
                // 가격표 섹션
                PriceTableView(workData: workData)
                
               
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
    
    // JSON 불러오기 함수
    private func loadWorkData() {
        workData = loadWorkItems(from: category.fileName)
    }
    
    // 숫자 포맷팅 함수
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    PriceAndProfileView(category: .basic)
}
