import SwiftUI

struct StandardPriceView: View {
    @StateObject private var priceLoader = StandardPriceLoader()
    @State private var searchText = ""
    @State private var selectedCategory = "가설공사"
    
    private let categories = ["가설공사", "토공사", "말뚝·지지공", "철거공사", "흙운반", "옹벽·배면채움"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("공종명 또는 코드로 검색", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                
                // 카테고리 선택
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // 데이터 로딩 상태
                if priceLoader.isLoading {
                    Spacer()
                    ProgressView("표준단가 데이터 로딩 중...")
                    Spacer()
                } else if let errorMessage = priceLoader.errorMessage {
                    Spacer()
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Spacer()
                } else {
                    // 공종 목록
                    List {
                        let items = getFilteredItems()
                        
                        if items.isEmpty {
                            Text("검색 결과가 없습니다.")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(items, id: \.공종코드) { item in
                                StandardPriceRow(item: item)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("표준단가")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("새로고침") {
                        priceLoader.loadStandardPrices()
                    }
                }
            }
        }
    }
    
    private func getFilteredItems() -> [StandardPrice] {
        let categoryItems = priceLoader.getCategoryItems(selectedCategory)
        
        if searchText.isEmpty {
            return categoryItems
        } else {
            return categoryItems.filter { item in
                item.공종명칭.contains(searchText) || item.공종코드.contains(searchText)
            }
        }
    }
}

struct StandardPriceRow: View {
    let item: StandardPrice
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 기본 정보
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.공종명칭)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.공종코드)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(item.단가)원")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Text("노무비율: \(item.노무비율)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // 보정계수 정보 (접을 수 있음)
            if let correctionFactors = item.보정계수, !correctionFactors.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("보정계수 보기")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(correctionFactors.keys), id: \.self) { factorType in
                            if let factorValues = correctionFactors[factorType] {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(factorType)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    ForEach(Array(factorValues.keys), id: \.self) { range in
                                        if let factors = factorValues[range] {
                                            HStack {
                                                Text(range)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                
                                                Spacer()
                                                
                                                if let priceFactor = factors["단가"] {
                                                    Text("단가: ×\(String(format: "%.2f", priceFactor))")
                                                        .font(.caption2)
                                                        .foregroundColor(.blue)
                                                }
                                                
                                                if let laborFactor = factors["노무비율"] {
                                                    Text("노무: ×\(String(format: "%.2f", laborFactor))")
                                                        .font(.caption2)
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            .padding(.leading, 8)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StandardPriceView()
}
