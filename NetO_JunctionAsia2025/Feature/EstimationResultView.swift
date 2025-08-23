import SwiftUI

struct EstimationResultView: View {
    let estimation: EstimationResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 헤더
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI 견적 결과")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("머신러닝 모델을 통한 정확한 견적")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // 주요 결과 카드
                VStack(spacing: 16) {
                    // 총 비용 카드
                    ResultCard(
                        title: "총 공사 비용",
                        value: formatCurrency(estimation.predictions.total_cost_krw),
                        subtitle: "예상 총 비용",
                        icon: "dollarsign.circle.fill",
                        iconColor: .green,
                        confidenceInterval: estimation.predictions.cost_confidence_interval,
                        unit: "원"
                    )
                    
                    // 공사 기간 카드
                    ResultCard(
                        title: "총 공사 기간",
                        value: "\(estimation.predictions.total_duration_days)일",
                        subtitle: "예상 소요 기간",
                        icon: "calendar.circle.fill",
                        iconColor: .blue,
                        confidenceInterval: estimation.predictions.duration_confidence_interval,
                        unit: "일"
                    )
                }
                
                // 신뢰구간 상세 정보
                VStack(alignment: .leading, spacing: 16) {
                    Text("신뢰구간 상세")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 12) {
                        // 비용 신뢰구간
                        ConfidenceIntervalCard(
                            title: "비용 신뢰구간",
                            lower: estimation.predictions.cost_confidence_interval.lower,
                            upper: estimation.predictions.cost_confidence_interval.upper,
                            unit: "원",
                            color: .green
                        )
                        
                        // 공기 신뢰구간
                        ConfidenceIntervalCard(
                            title: "공기 신뢰구간",
                            lower: estimation.predictions.duration_confidence_interval.lower,
                            upper: estimation.predictions.duration_confidence_interval.upper,
                            unit: "일",
                            color: .blue
                        )
                    }
                }
                
                // ML 모델 정보
                if let modelInfo = estimation.model_info {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("AI 모델 정보")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        ModelInfoCard(modelInfo: modelInfo)
                    }
                }
                
                // 입력 특성 정보
                if let inputFeatures = estimation.input_features {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("입력 특성")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        InputFeaturesCard(inputFeatures: inputFeatures)
                    }
                }
                
                // 액션 버튼들
                VStack(spacing: 12) {
                    Button(action: {
                        // TODO: 견적서 다운로드
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("견적서 다운로드")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // TODO: 상세 분석
                    }) {
                        HStack {
                            Image(systemName: "chart.bar")
                            Text("상세 분석 보기")
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ResultCard 컴포넌트
struct ResultCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let confidenceInterval: ConfidenceInterval
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(iconColor)
            
            // 신뢰구간 표시
            HStack {
                Text("신뢰구간:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(formatValue(confidenceInterval.lower, unit: unit)) ~ \(formatValue(confidenceInterval.upper, unit: unit))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatValue(_ value: Int, unit: String) -> String {
        if unit == "원" {
            return formatCurrency(value)
        } else {
            return "\(value)\(unit)"
        }
    }
}

// MARK: - ConfidenceIntervalCard 컴포넌트
struct ConfidenceIntervalCard: View {
    let title: String
    let lower: Int
    let upper: Int
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("하한값")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatValue(lower))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("상한값")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatValue(upper))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                }
                
                Spacer()
                
                // 범위 표시
                VStack(alignment: .trailing, spacing: 4) {
                    Text("범위")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(upper - lower)\(unit)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func formatValue(_ value: Int) -> String {
        if unit == "원" {
            return formatCurrency(value)
        } else {
            return "\(value)\(unit)"
        }
    }
}

// MARK: - ModelInfoCard 컴포넌트
struct ModelInfoCard: View {
    let modelInfo: ModelInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                Text("모델 정보")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let modelName = modelInfo.model_name {
                    InfoRow(label: "모델명", value: modelName)
                }
                if let version = modelInfo.version {
                    InfoRow(label: "버전", value: version)
                }
                if let accuracy = modelInfo.accuracy {
                    InfoRow(label: "정확도", value: "\(accuracy)%")
                }
                if let trainingDate = modelInfo.training_date {
                    InfoRow(label: "학습일", value: trainingDate)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - InputFeaturesCard 컴포넌트
struct InputFeaturesCard: View {
    let inputFeatures: InputFeatures
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.orange)
                Text("입력 특성")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let area = inputFeatures.area {
                    InfoRow(label: "면적", value: "\(area)㎡")
                }
                if let floors = inputFeatures.floors {
                    InfoRow(label: "층수", value: "\(floors)층")
                }
                if let constructionType = inputFeatures.construction_type {
                    InfoRow(label: "공사 유형", value: constructionType)
                }
                if let location = inputFeatures.location {
                    InfoRow(label: "위치", value: location)
                }
                if let complexity = inputFeatures.complexity {
                    InfoRow(label: "복잡도", value: complexity)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - InfoRow 컴포넌트
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - 유틸리티 함수
private func formatCurrency(_ amount: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    
    if amount >= 10000 {
        let man = Double(amount) / 10000.0
        return "\(formatter.string(from: NSNumber(value: man)) ?? "0")만원"
    } else {
        return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")원"
    }
}

#Preview {
    NavigationView {
        EstimationResultView(estimation: EstimationResponse(
            predictions: Predictions(
                total_cost_krw: 15000000,
                total_duration_days: 120,
                cost_confidence_interval: ConfidenceInterval(lower: 12750000, upper: 17250000),
                duration_confidence_interval: ConfidenceInterval(lower: 96, upper: 144)
            ),
            input_features: InputFeatures(
                area: 34,
                floors: 2,
                construction_type: "주택",
                location: "서울",
                complexity: "보통"
            ),
            model_info: ModelInfo(
                model_name: "ConstructionCostPredictor",
                version: "1.0.0",
                accuracy: 95.2,
                training_date: "2024-01-15"
            )
        ))
    }
}
