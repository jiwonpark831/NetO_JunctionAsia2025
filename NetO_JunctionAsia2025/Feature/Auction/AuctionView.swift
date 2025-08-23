//
//  AuctionView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct AuctionView: View {
    @State private var selectedCategory: CategorySelection? = nil
    //    @State private var selectedSubcategory: String? = nil
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    NavigationLink(value: "categorySelect") {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundColor(Color(hex: "626262"))
                            
                            Spacer()
                            Text(selectedCategory?.sub ?? "What service do you need?")
                                .foregroundColor(Color(hex: "626262"))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(Color(hex: "F2F2F2"))
                        .cornerRadius(5)
                        
                    }
                    .padding(.top, 38)
                    
                    Spacer()
                    
                    if let selected = selectedCategory {
                        PriceAndProfileView(category: selected.main)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // AI 입찰 섹션
                    AIBiddingSection()
                }
                .padding(.horizontal, 35)
                .navigationDestination(for: String.self) { value in
                    if value == "categorySelect" {
                        CategorySelectView { main, sub in
                            selectedCategory = CategorySelection(main: main, sub: sub)
                            path.removeAll()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AuctionView()
}
