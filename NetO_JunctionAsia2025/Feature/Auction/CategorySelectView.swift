//
//  CategorySelectView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct CategorySelection {
    let main: MainCategory
    let sub: String
}

struct CategorySelectView: View {
    let onSelect: (MainCategory, String) -> Void
    @State private var selectedMain: MainCategory = .basic
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 헤더
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "626262"))
                }
                
                Spacer()
                Text("Select Category")
                    .font(.headline)
                    .foregroundColor(Color(hex: "FF7F17"))
                Spacer()
                Button(action: {
                
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hex: "626262"))
                }
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
                .frame(width: 170)
                .background(Color(hex: "ECECEC"))
                
                Divider()
                
                // 오른쪽: 서브카테고리
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(selectedMain.subcategories, id: \.self) { sub in
                            Button {
                                onSelect(selectedMain, sub)
                                dismiss()
                            } label: {
                                HStack {
                                    Text(sub)
                                        .foregroundStyle(Color.black)
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true) // 기본 백버튼 숨기기
        .navigationBarHidden(true)
    }
}

#Preview {
    CategorySelectView { _, _ in }
}
