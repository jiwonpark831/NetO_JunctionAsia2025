//
//  AuctionView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct AuctionView: View {
    @State private var selectedSubcategory: String? = nil
    @State private var path: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
                    VStack {
                        NavigationLink(value: "categorySelect") {
                            Text(selectedSubcategory ?? "What service do you need?")
                                .foregroundColor(Color(hex: "626262"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "F2F2F2"))
                                .cornerRadius(5)
                        }
                    }
                    .padding(.horizontal, 45)
                    .navigationDestination(for: String.self) { value in
                        if value == "categorySelect" {
                            CategorySelectView { sub in
                                selectedSubcategory = sub
                                path.removeAll() // 선택되면 이전 화면(AuctionView)으로 돌아가기
                            }
                        }
                     
                    }
                }
    }
}

#Preview {
    AuctionView()
}
