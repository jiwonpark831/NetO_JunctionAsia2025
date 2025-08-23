import Foundation
import SwiftUI

// MARK: - 견적 입력 모델
struct EstimationRequest: Codable {
    let startDate: String
    let size: Int              // 평수
    let floor: Int             // 층수
    let roomN: Int             // 방 개수
    let restroomN: Int         // 화장실 개수
    let construct: String      // RC | 목구조 | 철골 등
    let material: String       // 중급 마감 등
    let conditionTags: [String] // 도심, 펌프카제한, 소음규제 등
    
    // 🚨 새로 추가된 필드들
    let accessCondition: String    // 접근성 (양호/보통/제한적/매우제한적)
    let noiseRestriction: Bool    // 소음 제한
    let pumpTruckRestriction: Bool // 펌프카 제한
    let urbanArea: Bool           // 도시지역 여부
    let winterConstruction: Bool  // 동절기 공사 여부
    
    enum CodingKeys: String, CodingKey {
        case startDate, size, floor, roomN, restroomN, construct, material
        case conditionTags = "condition_tags"
        case accessCondition = "access_condition"
        case noiseRestriction = "noise_restriction"
        case pumpTruckRestriction = "pump_truck_restriction"
        case urbanArea = "urban_area"
        case winterConstruction = "winter_construction"
    }
}

// MARK: - API 응답 구조에 맞춘 모델들
struct PredictionResponse: Codable {
    let predictions: Predictions
    let breakdown: Breakdown?
    let calculationInfo: CalculationInfo?
    
    enum CodingKeys: String, CodingKey {
        case predictions
        case breakdown
        case calculationInfo = "calculation_info"
    }
}

struct Predictions: Codable {
    let totalCostKRW: Int
    let totalDurationDays: Int
    let totalLaborHours: Double?
    let hourlyWageUsed: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCostKRW = "total_cost_krw"
        case totalDurationDays = "total_duration_days"
        case totalLaborHours = "total_labor_hours"
        case hourlyWageUsed = "hourly_wage_used"
    }
}

struct Breakdown: Codable {
    let scaffolding: Int?
    let excavation: Int?
    let piling: Int?
    let rebar: Int?
    let concrete: Int?
    let waterproofing: Int?
}

struct CalculationInfo: Codable {
    let source: String?
    let calculationMethod: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case calculationMethod = "calculation_method"
        case timestamp
    }
}

// MARK: - 기존 견적 응답 모델 (호환성 유지)
struct EstimationResponse: Codable {
    let durationDays: Double
    let costKRW: Int
    let confidence: String?
    let explanation: String?
    let breakdown: Breakdown?
    
    enum CodingKeys: String, CodingKey {
        case durationDays = "duration_days"
        case costKRW = "cost_krw"
        case confidence, explanation, breakdown
    }
}

// MARK: - 표준단가 모델
struct StandardPrice: Codable {
    let 공종코드: String
    let 공종명칭: String
    let 단가: Int
    let 노무비율: String
    let 보정계수: [String: [String: [String: Double]]]?
}

struct ConstructionCategory: Codable {
    let 가설공사: [StandardPrice]?
    let 토공사: [StandardPrice]?
    let 말뚝지지공: [StandardPrice]?
    let 철거공사: [StandardPrice]?
    let 흙운반: [StandardPrice]?
    let 옹벽배면채움: [StandardPrice]?
    
    enum CodingKeys: String, CodingKey {
        case 가설공사, 토공사
        case 말뚝지지공 = "말뚝·지지공"
        case 철거공사, 흙운반
        case 옹벽배면채움 = "옹벽·배면채움"
    }
}

// MARK: - 견적 계산기
class ConstructionEstimator: ObservableObject {
    @Published var isLoading = false
    @Published var estimation: EstimationResponse?
    @Published var errorMessage: String?
    
    private let baseURL = MLConfig.predictionEndpoint
    
    func estimate(_ request: EstimationRequest) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // 백엔드가 기대하는 형식으로 데이터 변환
            let requestDict: [String: Any] = [
                "start_date": request.startDate,
                "size": request.size,
                "floor": request.floor,
                "room_n": request.roomN,
                "restroom_n": request.restroomN,
                "construct": request.construct,
                "material": request.material,
                "condition_tags": request.conditionTags,
                "access_condition": request.accessCondition,
                "noise_restriction": request.noiseRestriction,
                "pump_truck_restriction": request.pumpTruckRestriction,
                "urban_area": request.urbanArea,
                "winter_construction": request.winterConstruction,
                "total_rooms": request.roomN + request.restroomN,
                "project_type": "residential",
                "timestamp": Date().timeIntervalSince1970
            ]
            
            let url = URL(string: baseURL)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.timeoutInterval = 30.0
            
            // 요청 데이터 로깅
            let requestData = try JSONSerialization.data(withJSONObject: requestDict)
            print("📤 API 요청 데이터: \(String(data: requestData, encoding: .utf8) ?? "인코딩 실패")")
            print("🌐 API 엔드포인트: \(url)")
            
            urlRequest.httpBody = requestData
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            print("📥 API 응답 상태: \(response)")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                // 응답 데이터 로깅
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 응답 데이터: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        // 새로운 API 응답 구조로 파싱 시도
                        let predictionResponse = try JSONDecoder().decode(PredictionResponse.self, from: data)
                        
                        // 기존 EstimationResponse 형식으로 변환
                        let estimation = EstimationResponse(
                            durationDays: Double(predictionResponse.predictions.totalDurationDays),
                            costKRW: predictionResponse.predictions.totalCostKRW,
                            confidence: "실제 단가 계산",
                            explanation: "market.csv 기반 정확한 단가 계산 - 총 노무시간: \(predictionResponse.predictions.totalLaborHours ?? 0)시간, 시급: \(predictionResponse.predictions.hourlyWageUsed ?? 0)원",
                            breakdown: predictionResponse.breakdown
                        )
                        
                        await MainActor.run {
                            self.estimation = estimation
                            self.isLoading = false
                        }
                        
                        print("✅ ML 모델 견적 성공")
                        
                    } catch let parsingError {
                        print("⚠️ ML 모델 응답 파싱 실패: \(parsingError)")
                        print("🔄 로컬 견적으로 자동 전환")
                        
                        // ML 모델 파싱 실패 시 로컬 견적으로 자동 전환
                        let localEstimation = estimateLocal(request)
                        
                        await MainActor.run {
                            self.estimation = localEstimation
                            self.errorMessage = "ML 모델 연결에 실패하여 로컬 견적으로 계산했습니다. (응답 형식 오류)"
                            self.isLoading = false
                        }
                    }
                } else {
                    let errorMessage = "서버 오류: HTTP \(httpResponse.statusCode)"
                    print("❌ \(errorMessage)")
                    
                    // HTTP 404 등 서버 오류 시 로컬 견적으로 전환
                    let localEstimation = estimateLocal(request)
                    
                    await MainActor.run {
                        self.estimation = localEstimation
                        if httpResponse.statusCode == 404 {
                            self.errorMessage = "ML 모델 서버를 찾을 수 없습니다. 로컬 견적으로 계산했습니다."
                        } else {
                            self.errorMessage = "ML 모델 서버 오류로 로컬 견적으로 계산했습니다. (HTTP \(httpResponse.statusCode))"
                        }
                        self.isLoading = false
                    }
                }
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ API 호출 오류: \(error)")
            
            // 네트워크 오류 등으로 API 호출 자체가 실패한 경우 로컬 견적으로 전환
            let localEstimation = estimateLocal(request)
            
            await MainActor.run {
                self.estimation = localEstimation
                self.errorMessage = "ML 모델 연결 실패로 로컬 견적으로 계산했습니다. (네트워크 오류: \(error.localizedDescription))"
                self.isLoading = false
            }
        }
    }
    
    // 표준단가 기반 로컬 견적 (ML 모델 없을 때 대체용)
    func estimateLocal(_ request: EstimationRequest) -> EstimationResponse {
        let baseCostPerPyung: Double = 2500000.0 // 기본 평당 단가
        let baseDurationPerPyung: Double = 1.2 // 기본 평당 소요일수
        
        // 자재 등급별 보정계수
        let materialMultiplier: [String: Double] = [
            "기본": 0.8,
            "중급": 1.0,
            "고급": 1.3,
            "프리미엄": 1.6
        ]
        
        // 구조별 보정계수
        let constructMultiplier: [String: Double] = [
            "목구조": 0.7,
            "철골": 0.9,
            "RC": 1.0
        ]
        
        // 추가 조건별 보정계수
        var additionalMultiplier: Double = 1.0
        
        // 접근성 조건
        switch request.accessCondition {
        case "양호": additionalMultiplier *= 0.95
        case "보통": additionalMultiplier *= 1.0
        case "제한적": additionalMultiplier *= 1.15
        case "매우제한적": additionalMultiplier *= 1.3
        default: break
        }
        
        // 소음 제한
        if request.noiseRestriction { additionalMultiplier *= 1.1 }
        
        // 펌프카 제한
        if request.pumpTruckRestriction { additionalMultiplier *= 1.2 }
        
        // 도시 지역
        if request.urbanArea { additionalMultiplier *= 1.05 }
        
        // 동절기 공사
        if request.winterConstruction { additionalMultiplier *= 1.15 }
        
        // 조건별 보정계수
        let conditionMultiplier: Double = request.conditionTags.contains("도심") ? 1.2 : 1.0
        
        // 보정계수 값들 가져오기
        let materialMultiplierValue = materialMultiplier[request.material] ?? 1.0
        let constructMultiplierValue = constructMultiplier[request.construct] ?? 1.0
        
        // 비용 계산을 단계별로 분리
        let sizeDouble = Double(request.size)
        let baseCost = sizeDouble * baseCostPerPyung
        let materialAdjustedCost = baseCost * materialMultiplierValue
        let constructAdjustedCost = materialAdjustedCost * constructMultiplierValue
        let conditionAdjustedCost = constructAdjustedCost * conditionMultiplier
        let finalCost = conditionAdjustedCost * additionalMultiplier
        let estimatedCost = Int(finalCost)
        
        // 기간 계산을 단계별로 분리
        let baseDuration = sizeDouble * baseDurationPerPyung
        let materialAdjustedDuration = baseDuration * materialMultiplierValue
        let constructAdjustedDuration = materialAdjustedDuration * constructMultiplierValue
        let conditionAdjustedDuration = constructAdjustedDuration * conditionMultiplier
        let estimatedDuration = conditionAdjustedDuration * additionalMultiplier
        
        return EstimationResponse(
            durationDays: estimatedDuration,
            costKRW: estimatedCost,
            confidence: "로컬 계산",
            explanation: "표준단가 기반 추정치입니다. (자재: \(request.material), 구조: \(request.construct), 접근성: \(request.accessCondition), 추가조건: \(request.conditionTags.joined(separator: ", "))) ML 모델 연결 후 더 정확한 견적을 받을 수 있습니다.",
            breakdown: nil // 로컬 계산은 breakdown 정보를 제공하지 않음
        )
    }
}
