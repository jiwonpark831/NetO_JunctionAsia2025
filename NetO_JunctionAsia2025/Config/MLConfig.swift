import Foundation

// MARK: - ML 모델 설정
struct MLConfig {
    // ML 모델 API 엔드포인트
    static let predictionEndpoint = "https://predict-entgnwhmxq-uc.a.run.app"
    
    // 모델 버전 정보
    static let modelVersion = "v1.0.0"
    static let lastUpdated = "2025-01-27"
    
    // 예측 신뢰도 임계값
    static let confidenceThreshold = 0.8
    
    // 재시도 설정
    static let maxRetries = 3
    static let retryDelay: TimeInterval = 2.0
    
    // 캐시 설정
    static let cacheExpiration: TimeInterval = 3600 // 1시간
    
    // 로컬 폴백 설정
    static let enableLocalFallback = true
    static let localFallbackThreshold = 0.6
}

// MARK: - API 응답 상태
enum APIStatus: String, Codable {
    case success = "success"
    case error = "error"
    case pending = "pending"
    case fallback = "fallback"
}

// MARK: - 예측 품질 지표
struct PredictionQuality: Codable {
    let confidence: Double
    let accuracy: Double?
    let lastTrainingDate: String?
    let dataPoints: Int?
    let modelVersion: String
}

// MARK: - 견적 히스토리 모델
struct EstimationHistory: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    let request: EstimationRequest
    let response: EstimationResponse
    let quality: PredictionQuality?
    let apiStatus: APIStatus
    
    enum CodingKeys: String, CodingKey {
        case timestamp, request, response, quality, apiStatus
    }
}

// MARK: - 사용자 설정
struct UserPreferences: Codable {
    var enableNotifications = true
    var defaultMaterial = "중급"
    var defaultConstruct = "RC"
    var preferredConditions: [String] = []
    var currencyFormat = "KRW"
    var language = "ko"
}
