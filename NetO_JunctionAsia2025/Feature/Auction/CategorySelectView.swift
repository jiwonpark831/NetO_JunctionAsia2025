//
//  CategorySelectView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct CategorySelectView: View {
    @State private var selectedMain: MainCategory = .foundation
    let onSelect: (String) -> Void   // 선택 결과를 AuctionView로 전달

    var body: some View {
        VStack(spacing: 0) {
            // 상단 헤더
            HStack {
//                Text("Select Category")
//                    .font(.headline)
                Spacer()
            }
            .padding()

            HStack(spacing: 0) {
                // 왼쪽: 메인 카테고리
                ScrollView {
                    VStack {
                        ForEach(MainCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .fontWeight(selectedMain == category ? .bold : .regular)
                                .foregroundColor(selectedMain == category ? .black : Color(hex: "B5B5B5"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    selectedMain == category ?
                                        .white : Color(hex: "ECECEC")
                                )
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedMain = category
                                }
                        }
                    }
                    .padding()
                }
                .frame(width: 200)
                .background(Color(hex: "ECECEC"))

                Divider()

                // 오른쪽: 서브카테고리
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(selectedMain.subcategories, id: \.self) { sub in
                            Button {
                                onSelect(sub) // 선택 후 값 전달
                            } label: {
                                Text(sub)
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Select Category")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbarColorScheme(.dark, for: .navigationBar)
//        .toolbarBackground(Color.white, for: .navigationBar)
    }
}

#Preview {
    CategorySelectView { _ in }
}
