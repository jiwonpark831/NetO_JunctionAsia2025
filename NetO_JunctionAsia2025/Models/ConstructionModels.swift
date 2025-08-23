import Foundation
import SwiftUI

// MARK: - Firebase Functions 응답 모델 (새로운 구조)
struct EstimationResponse: Codable {
    let predictions: Predictions
    let input_features: InputFeatures?
    let model_info: ModelInfo?
    
    enum CodingKeys: String, CodingKey {
        case predictions
        case input_features
        case model_info
    }
}

// MARK: - Firebase Functions 실제 응답 구조 (새로 추가)
struct FirebaseEstimationResponse: Codable {
    let cost_prediction: Double
    let duration_prediction: Double
    let cost_confidence: ConfidenceRange
    let duration_confidence: ConfidenceRange
    let input_data: FirebaseInputData
    let prediction_timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case cost_prediction
        case duration_prediction
        case cost_confidence
        case duration_confidence
        case input_data
        case prediction_timestamp
    }
}

struct ConfidenceRange: Codable {
    let lower: Double
    let upper: Double
}

struct FirebaseInputData: Codable {
    let soil_condition: String
    let access_condition: String
    let pump_truck_restriction: Bool
    let noise_restriction: Bool
    let total_rooms: Int
    let condition_tags: [String]
    let material_grade: String
    let start_date: String
    let winter_construction: Bool
    let project_type: String
    let timestamp: Double
    let size: Int
    let floor_count: Int
    let bathroom_count: Int
    let urban_area: Bool
    let room_count: Int
    let construction_type: String
}

struct Predictions: Codable {
    let total_cost_krw: Int
    let total_duration_days: Int
    let cost_confidence_interval: ConfidenceInterval
    let duration_confidence_interval: ConfidenceInterval
}

struct ConfidenceInterval: Codable {
    let lower: Int
    let upper: Int
}

struct InputFeatures: Codable {
    let area: Int?
    let floors: Int?
    let construction_type: String?
    let location: String?
    let complexity: String?
    let material_grade: String?
    let access_condition: String?
    let noise_restriction: Bool?
    let pump_truck_restriction: Bool?
    let urban_area: Bool?
    let winter_construction: Bool?
    
    init(area: Int? = nil, floors: Int? = nil, construction_type: String? = nil, location: String? = nil, complexity: String? = nil, material_grade: String? = nil, access_condition: String? = nil, noise_restriction: Bool? = nil, pump_truck_restriction: Bool? = nil, urban_area: Bool? = nil, winter_construction: Bool? = nil) {
        self.area = area
        self.floors = floors
        self.construction_type = construction_type
        self.location = location
        self.complexity = complexity
        self.material_grade = material_grade
        self.access_condition = access_condition
        self.noise_restriction = noise_restriction
        self.pump_truck_restriction = pump_truck_restriction
        self.urban_area = urban_area
        self.winter_construction = winter_construction
    }
}

struct ModelInfo: Codable {
    let model_name: String?
    let version: String?
    let accuracy: Double?
    let training_date: String?
}

// MARK: - 기존 견적 응답 모델 (호환성 유지)
struct LegacyEstimationResponse: Codable {
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

// MARK: - 견적 입력 모델
struct EstimationRequest: Codable {
    let startDate: String
    let size: Int              // 평수
    let floor_count: Int             // 층수
    let room_count: Int             // 방 개수
    let bathroom_count: Int         // 화장실 개수
    let construction_type: String      // RC | 목구조 | 철골 등
    let material_grade: String       // 중급 마감 등
    let soil_condition: String       // 지반 상태 (보통/연약/양호)
    let conditionTags: [String] // 도심, 펌프카제한, 소음규제 등
    
    // 🚨 새로 추가된 필드들
    let accessCondition: String    // 접근성 (양호/보통/제한적/매우제한적)
    let noiseRestriction: Bool    // 소음 제한
    let pumpTruckRestriction: Bool // 펌프카 제한
    let urbanArea: Bool           // 도시지역 여부
    let winterConstruction: Bool  // 동절기 공사 여부
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case size
        case floor_count
        case room_count
        case bathroom_count
        case construction_type
        case material_grade
        case soil_condition
        case conditionTags = "condition_tags"
        case accessCondition = "access_condition"
        case noiseRestriction = "noise_restriction"
        case pumpTruckRestriction = "pump_truck_restriction"
        case urbanArea = "urban_area"
        case winterConstruction = "winter_construction"
    }
}

// MARK: - API 응답 구조에 맞춘 모델들 (기존 호환성)
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
            // Firebase Functions가 기대하는 형식으로 데이터 변환
            let requestDict: [String: Any] = [
                "start_date": request.startDate,
                "size": request.size,
                "floor_count": request.floor_count,
                "room_count": request.room_count,
                "bathroom_count": request.bathroom_count,
                "construction_type": request.construction_type,
                "material_grade": request.material_grade,
                "soil_condition": request.soil_condition,
                "condition_tags": request.conditionTags,
                "access_condition": request.accessCondition,
                "noise_restriction": request.noiseRestriction,
                "pump_truck_restriction": request.pumpTruckRestriction,
                "urban_area": request.urbanArea,
                "winter_construction": request.winterConstruction,
                "total_rooms": request.room_count + request.bathroom_count,
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
            print("📤 Firebase Functions 요청 데이터: \(String(data: requestData, encoding: .utf8) ?? "인코딩 실패")")
            print("🌐 Firebase Functions 엔드포인트: \(url)")
            print("🔍 요청 헤더: \(urlRequest.allHTTPHeaderFields ?? [:])")
            
            urlRequest.httpBody = requestData
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            print("📥 Firebase Functions 응답 상태: \(response)")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                // 응답 데이터 로깅
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 응답 데이터: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        // 먼저 새로운 Firebase Functions 응답 구조로 파싱 시도
                        let firebaseResponse = try JSONDecoder().decode(FirebaseEstimationResponse.self, from: data)
                        
                        // Firebase 응답을 기존 구조로 변환
                        let estimation = EstimationResponse(
                            predictions: Predictions(
                                total_cost_krw: Int(firebaseResponse.cost_prediction),
                                total_duration_days: Int(firebaseResponse.duration_prediction),
                                cost_confidence_interval: ConfidenceInterval(
                                    lower: Int(firebaseResponse.cost_confidence.lower),
                                    upper: Int(firebaseResponse.cost_confidence.upper)
                                ),
                                duration_confidence_interval: ConfidenceInterval(
                                    lower: Int(firebaseResponse.duration_confidence.lower),
                                    upper: Int(firebaseResponse.duration_confidence.upper)
                                )
                            ),
                            input_features: InputFeatures(
                                area: firebaseResponse.input_data.size,
                                floors: firebaseResponse.input_data.floor_count,
                                construction_type: firebaseResponse.input_data.construction_type,
                                location: "Firebase ML",
                                complexity: "ML 예측",
                                material_grade: firebaseResponse.input_data.material_grade,
                                access_condition: firebaseResponse.input_data.access_condition,
                                noise_restriction: firebaseResponse.input_data.noise_restriction,
                                pump_truck_restriction: firebaseResponse.input_data.pump_truck_restriction,
                                urban_area: firebaseResponse.input_data.urban_area,
                                winter_construction: firebaseResponse.input_data.winter_construction
                            ),
                            model_info: ModelInfo(
                                model_name: "Firebase ML 모델",
                                version: "1.0.0",
                                accuracy: 85.0,
                                training_date: firebaseResponse.prediction_timestamp
                            )
                        )
                        
                        await MainActor.run {
                            self.estimation = estimation
                            self.isLoading = false
                        }
                        
                        print("✅ Firebase Functions 견적 성공 (새로운 구조)")
                        
                    } catch let parsingError {
                        print("⚠️ Firebase Functions 응답 파싱 실패: \(parsingError)")
                        print("🔄 로컬 견적으로 자동 전환")
                        
                        // Firebase Functions 파싱 실패 시 로컬 견적으로 자동 전환
                        let localEstimation = estimateLocal(request)
                        
                        await MainActor.run {
                            // 로컬 견적을 새로운 구조로 변환
                            self.estimation = EstimationResponse(
                                predictions: Predictions(
                                    total_cost_krw: localEstimation.costKRW,
                                    total_duration_days: Int(localEstimation.durationDays),
                                    cost_confidence_interval: ConfidenceInterval(
                                        lower: Int(Double(localEstimation.costKRW) * 0.85),
                                        upper: Int(Double(localEstimation.costKRW) * 1.15)
                                    ),
                                    duration_confidence_interval: ConfidenceInterval(
                                        lower: Int(localEstimation.durationDays * 0.8),
                                        upper: Int(localEstimation.durationDays * 1.2)
                                    )
                                ),
                                input_features: InputFeatures(
                                    area: request.size,
                                    floors: request.floor_count,
                                    construction_type: request.construction_type,
                                    location: "로컬",
                                    complexity: "보통",
                                    material_grade: request.material_grade,
                                    access_condition: request.accessCondition,
                                    noise_restriction: request.noiseRestriction,
                                    pump_truck_restriction: request.pumpTruckRestriction,
                                    urban_area: request.urbanArea,
                                    winter_construction: request.winterConstruction
                                ),
                                model_info: ModelInfo(
                                    model_name: "로컬 계산기",
                                    version: "1.0.0",
                                    accuracy: 75.0,
                                    training_date: "N/A"
                                )
                            )
                            self.errorMessage = "Firebase Functions 연결에 실패하여 로컬 견적으로 계산했습니다. (응답 형식 오류)"
                            self.isLoading = false
                        }
                    }
                } else {
                    let errorMessage = "Firebase Functions 오류: HTTP \(httpResponse.statusCode)"
                    print("❌ \(errorMessage)")
                    
                    // HTTP 오류 시 로컬 견적으로 전환
                    let localEstimation = estimateLocal(request)
                    
                    await MainActor.run {
                        // 로컬 견적을 새로운 구조로 변환
                        self.estimation = EstimationResponse(
                            predictions: Predictions(
                                total_cost_krw: localEstimation.costKRW,
                                total_duration_days: Int(localEstimation.durationDays),
                                cost_confidence_interval: ConfidenceInterval(
                                    lower: Int(Double(localEstimation.costKRW) * 0.85),
                                    upper: Int(Double(localEstimation.costKRW) * 1.15)
                                ),
                                duration_confidence_interval: ConfidenceInterval(
                                    lower: Int(localEstimation.durationDays * 0.8),
                                    upper: Int(localEstimation.durationDays * 1.2)
                                )
                            ),
                            input_features: InputFeatures(
                                area: request.size,
                                floors: request.floor_count,
                                construction_type: request.construction_type,
                                location: "로컬",
                                complexity: "보통",
                                material_grade: request.material_grade,
                                access_condition: request.accessCondition,
                                noise_restriction: request.noiseRestriction,
                                pump_truck_restriction: request.pumpTruckRestriction,
                                urban_area: request.urbanArea,
                                winter_construction: request.winterConstruction
                            ),
                            model_info: ModelInfo(
                                model_name: "로컬 계산기",
                                version: "1.0.0",
                                accuracy: 75.0,
                                training_date: "N/A"
                            )
                        )
                        if httpResponse.statusCode == 404 {
                            self.errorMessage = "Firebase Functions를 찾을 수 없습니다. 로컬 견적으로 계산했습니다."
                        } else {
                            self.errorMessage = "Firebase Functions 오류로 로컬 견적으로 계산했습니다. (HTTP \(httpResponse.statusCode))"
                        }
                        self.isLoading = false
                    }
                }
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ Firebase Functions 호출 오류: \(error)")
            
            // 네트워크 오류 등으로 Firebase Functions 호출 자체가 실패한 경우 로컬 견적으로 전환
            let localEstimation = estimateLocal(request)
            
            await MainActor.run {
                // 로컬 견적을 새로운 구조로 변환
                self.estimation = EstimationResponse(
                    predictions: Predictions(
                        total_cost_krw: localEstimation.costKRW,
                        total_duration_days: Int(localEstimation.durationDays),
                        cost_confidence_interval: ConfidenceInterval(
                            lower: Int(Double(localEstimation.costKRW) * 0.85),
                            upper: Int(Double(localEstimation.costKRW) * 1.15)
                        ),
                        duration_confidence_interval: ConfidenceInterval(
                            lower: Int(localEstimation.durationDays * 0.8),
                            upper: Int(localEstimation.durationDays * 1.2)
                        )
                    ),
                    input_features: InputFeatures(
                        area: request.size,
                        floors: request.floor_count,
                        construction_type: request.construction_type,
                        location: "로컬",
                        complexity: "보통",
                        material_grade: request.material_grade,
                        access_condition: request.accessCondition,
                        noise_restriction: request.noiseRestriction,
                        pump_truck_restriction: request.pumpTruckRestriction,
                        urban_area: request.urbanArea,
                        winter_construction: request.winterConstruction
                    ),
                    model_info: ModelInfo(
                        model_name: "로컬 계산기",
                        version: "1.0.0",
                        accuracy: 75.0,
                        training_date: "N/A"
                    )
                )
                self.errorMessage = "Firebase Functions 연결 실패로 로컬 견적으로 계산했습니다. (네트워크 오류: \(error.localizedDescription))"
                self.isLoading = false
            }
        }
    }
    
    // 표준단가 기반 로컬 견적 (Firebase Functions 없을 때 대체용)
    func estimateLocal(_ request: EstimationRequest) -> LegacyEstimationResponse {
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
        let materialMultiplierValue = materialMultiplier[request.material_grade] ?? 1.0
        let constructMultiplierValue = constructMultiplier[request.construction_type] ?? 1.0
        
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
        
        return LegacyEstimationResponse(
            durationDays: estimatedDuration,
            costKRW: estimatedCost,
            confidence: "로컬 계산",
            explanation: "표준단가 기반 추정치입니다. (자재: \(request.material_grade), 구조: \(request.construction_type), 접근성: \(request.accessCondition), 추가조건: \(request.conditionTags.joined(separator: ", "))) Firebase Functions 연결 후 더 정확한 견적을 받을 수 있습니다.",
            breakdown: nil // 로컬 계산은 breakdown 정보를 제공하지 않음
        )
    }
}
