import Foundation
import Combine

class StandardPriceLoader: ObservableObject {
    @Published var constructionData: ConstructionCategory?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadStandardPrices()
    }
    
    func loadStandardPrices() {
        isLoading = true
        errorMessage = nil
        
        guard let url = Bundle.main.url(forResource: "Construction unit price", withExtension: "json") else {
            errorMessage = "표준단가 데이터 파일을 찾을 수 없습니다."
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            constructionData = try decoder.decode(ConstructionCategory.self, from: data)
            isLoading = false
        } catch {
            errorMessage = "표준단가 데이터 로드 중 오류가 발생했습니다: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // 특정 공종의 단가 조회
    func getPrice(for code: String) -> StandardPrice? {
        guard let data = constructionData else { return nil }
        
        // 모든 카테고리에서 검색
        let allCategories: [[StandardPrice]?] = [
            data.가설공사,
            data.토공사,
            data.말뚝지지공,
            data.철거공사,
            data.흙운반,
            data.옹벽배면채움
        ]
        
        for category in allCategories {
            if let category = category {
                if let found = category.first(where: { $0.공종코드 == code }) {
                    return found
                }
            }
        }
        
        return nil
    }
    
    // 공종명으로 검색
    func searchByName(_ name: String) -> [StandardPrice] {
        guard let data = constructionData else { return [] }
        
        var results: [StandardPrice] = []
        let allCategories: [[StandardPrice]?] = [
            data.가설공사,
            data.토공사,
            data.말뚝지지공,
            data.철거공사,
            data.흙운반,
            data.옹벽배면채움
        ]
        
        for category in allCategories {
            if let category = category {
                let filtered = category.filter { $0.공종명칭.contains(name) }
                results.append(contentsOf: filtered)
            }
        }
        
        return results
    }
    
    // 카테고리별 공종 목록 조회
    func getCategoryItems(_ category: String) -> [StandardPrice] {
        guard let data = constructionData else { return [] }
        
        switch category {
        case "가설공사":
            return data.가설공사 ?? []
        case "토공사":
            return data.토공사 ?? []
        case "말뚝·지지공":
            return data.말뚝지지공 ?? []
        case "철거공사":
            return data.철거공사 ?? []
        case "흙운반":
            return data.흙운반 ?? []
        case "옹벽·배면채움":
            return data.옹벽배면채움 ?? []
        default:
            return []
        }
    }
    
    // 보정계수 적용된 단가 계산
    func calculateAdjustedPrice(for code: String, parameters: [String: String]) -> Double? {
        guard let standardPrice = getPrice(for: code) else { return nil }
        
        var adjustedPrice = Double(standardPrice.단가)
        
        // 보정계수 적용
        if let correctionFactors = standardPrice.보정계수 {
            for (factorType, factorValues) in correctionFactors {
                if let parameterValue = parameters[factorType] {
                    for (range, factors) in factorValues {
                        if range.contains(parameterValue) || parameterValue.contains(range) {
                            if let priceFactor = factors["단가"] {
                                adjustedPrice *= priceFactor
                            }
                        }
                    }
                }
            }
        }
        
        return adjustedPrice
    }
    
    // 카테고리별 총 공종 수
    var totalItemCount: Int {
        guard let data = constructionData else { return 0 }
        
        var total = 0
        
        // 각 카테고리별로 개수를 더하기
        if let 가설공사Count = data.가설공사?.count {
            total += 가설공사Count
        }
        
        if let 토공사Count = data.토공사?.count {
            total += 토공사Count
        }
        
        if let 말뚝지지공Count = data.말뚝지지공?.count {
            total += 말뚝지지공Count
        }
        
        if let 철거공사Count = data.철거공사?.count {
            total += 철거공사Count
        }
        
        if let 흙운반Count = data.흙운반?.count {
            total += 흙운반Count
        }
        
        if let 옹벽배면채움Count = data.옹벽배면채움?.count {
            total += 옹벽배면채움Count
        }
        
        return total
    }
}
