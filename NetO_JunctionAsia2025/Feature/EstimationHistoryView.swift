import SwiftUI

struct EstimationHistoryView: View {
    @State private var historyItems: [EstimationHistory] = []
    @State private var searchText = ""
    @State private var selectedFilter = "전체"
    
    private let filterOptions = ["전체", "최근 7일", "최근 30일", "최근 90일"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 및 필터
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("프로젝트 검색", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filterOptions, id: \.self) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                    applyFilter()
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color.blue : Color(.systemGray5))
                                        .foregroundColor(selectedFilter == filter ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // 히스토리 목록
                if historyItems.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("견적 히스토리가 없습니다")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("첫 번째 견적을 계산해보세요!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredHistoryItems) { item in
                            HistoryRowView(item: item)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("견적 히스토리")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("새로고침") {
                        loadHistory()
                    }
                }
            }
        }
        .onAppear {
            loadHistory()
        }
    }
    
    private var filteredHistoryItems: [EstimationHistory] {
        let filtered = historyItems.filter { item in
            if !searchText.isEmpty {
                return item.request.construct.contains(searchText) ||
                       String(item.request.size).contains(searchText) ||
                       item.request.material.contains(searchText)
            }
            return true
        }
        
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
    
    private func loadHistory() {
        // TODO: 실제 데이터베이스에서 로드
        // 현재는 샘플 데이터 사용
        historyItems = [
            EstimationHistory(
                timestamp: Date().addingTimeInterval(-86400), // 1일 전
                request: EstimationRequest(
                    startDate: "2025-01-26",
                    size: 34,
                    floor: 2,
                    roomN: 3,
                    restroomN: 2,
                    construct: "RC",
                    material: "중급",
                    conditionTags: ["도심", "펌프카제한"],
                    accessCondition: "보통",
                    noiseRestriction: false,
                    pumpTruckRestriction: true,
                    urbanArea: true,
                    winterConstruction: false
                ),
                response: EstimationResponse(
                    durationDays: 45,
                    costKRW: 85000000,
                    confidence: "ML 모델",
                    explanation: "고정밀 예측 모델을 통한 견적",
                    breakdown: nil
                ),
                quality: PredictionQuality(
                    confidence: 0.92,
                    accuracy: 0.89,
                    lastTrainingDate: "2025-01-20",
                    dataPoints: 1250,
                    modelVersion: "v1.0.0"
                ),
                apiStatus: .success
            ),
            EstimationHistory(
                timestamp: Date().addingTimeInterval(-172800), // 2일 전
                request: EstimationRequest(
                    startDate: "2025-01-25",
                    size: 45,
                    floor: 3,
                    roomN: 4,
                    restroomN: 2,
                    construct: "RC",
                    material: "고급",
                    conditionTags: ["도심", "소음규제"],
                    accessCondition: "제한적",
                    noiseRestriction: true,
                    pumpTruckRestriction: false,
                    urbanArea: true,
                    winterConstruction: false
                ),
                response: EstimationResponse(
                    durationDays: 52,
                    costKRW: 120000000,
                    confidence: "ML 모델",
                    explanation: "고정밀 예측 모델을 통한 견적",
                    breakdown: nil
                ),
                quality: PredictionQuality(
                    confidence: 0.88,
                    accuracy: 0.85,
                    lastTrainingDate: "2025-01-20",
                    dataPoints: 1250,
                    modelVersion: "v1.0.0"
                ),
                apiStatus: .success
            )
        ]
    }
    
    private func applyFilter() {
        // 필터 적용 로직
        loadHistory()
    }
}

struct HistoryRowView: View {
    let item: EstimationHistory
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 기본 정보
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(item.request.size)평 \(item.request.construct) \(item.request.material)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(item.response.durationDays))일")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Text(formatCurrency(item.response.costKRW))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            
            // 상태 표시
            HStack {
                StatusBadge(status: item.apiStatus)
                
                if let quality = item.quality {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.caption)
                        Text("신뢰도: \(Int(quality.confidence * 100))%")
                            .font(.caption)
                    }
                    .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            // 상세 정보 (접을 수 있음)
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        DetailRow(title: "구조", value: item.request.construct)
                        DetailRow(title: "자재", value: item.request.material)
                        DetailRow(title: "층수", value: "\(item.request.floor)층")
                        DetailRow(title: "방/화장실", value: "\(item.request.roomN)개/\(item.request.restroomN)개")
                        
                        if !item.request.conditionTags.isEmpty {
                            DetailRow(title: "특수조건", value: item.request.conditionTags.joined(separator: ", "))
                        }
                    }
                    
                    if let quality = item.quality {
                        VStack(alignment: .leading, spacing: 6) {
                            DetailRow(title: "정확도", value: "\(Int((quality.accuracy ?? 0) * 100))%")
                            DetailRow(title: "모델버전", value: quality.modelVersion)
                            if let dataPoints = quality.dataPoints {
                                DetailRow(title: "학습데이터", value: "\(dataPoints)건")
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .padding(.vertical, 8)
    }
    
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
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct StatusBadge: View {
    let status: APIStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch status {
        case .success:
            return .green
        case .error:
            return .red
        case .pending:
            return .orange
        case .fallback:
            return .blue
        }
    }
    
    private var statusText: String {
        switch status {
        case .success:
            return "성공"
        case .error:
            return "오류"
        case .pending:
            return "처리중"
        case .fallback:
            return "로컬"
        }
    }
}

#Preview {
    EstimationHistoryView()
}
