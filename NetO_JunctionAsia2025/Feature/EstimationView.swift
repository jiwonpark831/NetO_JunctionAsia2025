import SwiftUI

struct EstimationView: View {
    @StateObject private var estimator = ConstructionEstimator()
    @State private var startDate = Date()
    @State private var size = ""
    @State private var floor_count = ""
    @State private var room_count = ""
    @State private var bathroom_count = ""
    @State private var selectedConstructionType = "RC"
    @State private var selectedMaterialGrade = "중급"
    @State private var selectedSoilCondition = "보통"
    @State private var selectedConditions: Set<String> = []
    
    // 🚨 새로 추가된 상태 변수들
    @State private var selectedAccessCondition = "보통"
    @State private var noiseRestriction = false
    @State private var pumpTruckRestriction = false
    @State private var urbanArea = true
    @State private var winterConstruction = false
    
    private let constructOptions = ["철근콘크리트", "철골철근콘크리트", "철골조", "순철골", "목재구조", "벽돌구조", "경량철골"]
    private let materialOptions = ["기본", "중급", "고급", "프리미엄"]
    private let soilConditionOptions = ["보통", "연약", "양호"]
    private let conditionOptions = ["도심", "펌프카제한", "소음규제", "지반연약", "장비양호"]
    private let accessConditionOptions = ["양호", "보통", "제한적", "매우제한적"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 프로젝트 기본 정보
                    VStack(alignment: .leading, spacing: 15) {
                        Text("프로젝트 기본 정보")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("착공일")
                                    .frame(width: 80, alignment: .leading)
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            
                            HStack {
                                Text("평수")
                                    .frame(width: 80, alignment: .leading)
                                TextField("평수 입력", text: $size)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            HStack {
                                Text("층수")
                                    .frame(width: 80, alignment: .leading)
                                TextField("층수 입력", text: $floor_count)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            HStack {
                                Text("방 개수")
                                    .frame(width: 80, alignment: .leading)
                                TextField("방 개수", text: $room_count)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            HStack {
                                Text("화장실")
                                    .frame(width: 80, alignment: .leading)
                                TextField("화장실 개수", text: $bathroom_count)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 구조 및 자재 선택
                    VStack(alignment: .leading, spacing: 15) {
                        Text("구조 및 자재")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("구조")
                                    .frame(width: 80, alignment: .leading)
                                Picker("구조 선택", selection: $selectedConstructionType) {
                                    ForEach(constructOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("자재 등급")
                                    .frame(width: 80, alignment: .leading)
                                Picker("자재 등급", selection: $selectedMaterialGrade) {
                                    ForEach(materialOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("지반 상태")
                                    .frame(width: 80, alignment: .leading)
                                Picker("지반 상태 선택", selection: $selectedSoilCondition) {
                                    ForEach(soilConditionOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 특수 조건 선택
                    VStack(alignment: .leading, spacing: 15) {
                        Text("특수 조건")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            ForEach(conditionOptions, id: \.self) { condition in
                                Button(action: {
                                    if selectedConditions.contains(condition) {
                                        selectedConditions.remove(condition)
                                    } else {
                                        selectedConditions.insert(condition)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedConditions.contains(condition) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedConditions.contains(condition) ? .blue : .gray)
                                        Text(condition)
                                            .foregroundColor(selectedConditions.contains(condition) ? .blue : .primary)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedConditions.contains(condition) ? Color.blue.opacity(0.1) : Color(.systemGray5))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 🚨 접근성 및 제한사항
                    VStack(alignment: .leading, spacing: 15) {
                        Text("접근성 및 제한사항")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("접근성")
                                    .frame(width: 80, alignment: .leading)
                                Picker("접근성 선택", selection: $selectedAccessCondition) {
                                    ForEach(accessConditionOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("소음 제한")
                                    .frame(width: 80, alignment: .leading)
                                Toggle("", isOn: $noiseRestriction)
                                    .labelsHidden()
                            }
                            
                            HStack {
                                Text("펌프카 제한")
                                    .frame(width: 80, alignment: .leading)
                                Toggle("", isOn: $pumpTruckRestriction)
                                    .labelsHidden()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 🚨 지역 및 계절 특성
                    VStack(alignment: .leading, spacing: 15) {
                        Text("지역 및 계절 특성")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("도시지역")
                                    .frame(width: 80, alignment: .leading)
                                Toggle("", isOn: $urbanArea)
                                    .labelsHidden()
                            }
                            
                            HStack {
                                Text("동절기 공사")
                                    .frame(width: 80, alignment: .leading)
                                Toggle("", isOn: $winterConstruction)
                                    .labelsHidden()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 견적 계산 버튼
                    Button(action: calculateEstimation) {
                        HStack {
                            if estimator.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "function")
                            }
                            Text(estimator.isLoading ? "계산 중..." : "견적 계산")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(estimator.isLoading || !isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    
                    // 견적 결과 표시
                    if let estimation = estimator.estimation {
                        EstimationResultView(estimation: estimation)
                    }
                    
                    // 오류 메시지 표시
                    if let errorMessage = estimator.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("건설 견적")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var isFormValid: Bool {
        !size.isEmpty && !floor_count.isEmpty && !room_count.isEmpty && !bathroom_count.isEmpty &&
        Int(size) != nil && Int(floor_count) != nil && Int(room_count) != nil && Int(bathroom_count) != nil
    }
    
    private func calculateEstimation() {
        guard let sizeInt = Int(size),
              let floorInt = Int(floor_count),
              let roomCountInt = Int(room_count),
              let bathroomCountInt = Int(bathroom_count) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        
        let request = EstimationRequest(
            startDate: startDateString,
            size: sizeInt,
            floor_count: floorInt,
            room_count: roomCountInt,
            bathroom_count: bathroomCountInt,
            construction_type: selectedConstructionType,
            material_grade: selectedMaterialGrade,
            soil_condition: selectedSoilCondition,
            conditionTags: Array(selectedConditions),
            accessCondition: selectedAccessCondition,
            noiseRestriction: noiseRestriction,
            pumpTruckRestriction: pumpTruckRestriction,
            urbanArea: urbanArea,
            winterConstruction: winterConstruction
        )
        
        // ML 모델 호출 시도
        Task {
            do {
                try await estimator.estimate(request)
            } catch {
                // ML 모델 실패 시 로컬 견적으로 폴백
                await performLocalEstimation(request)
            }
        }
    }
    
    private func performLocalEstimation(_ request: EstimationRequest) async {
        let localEstimation = estimator.estimateLocal(request)
        await MainActor.run {
            // 로컬 견적을 새로운 구조로 변환
            estimator.estimation = EstimationResponse(
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
                    area: Int(size),
                    floors: Int(floor_count),
                    construction_type: selectedConstructionType,
                    location: "로컬",
                    complexity: "보통",
                    material_grade: selectedMaterialGrade,
                    access_condition: selectedAccessCondition,
                    noise_restriction: noiseRestriction,
                    pump_truck_restriction: pumpTruckRestriction,
                    urban_area: urbanArea,
                    winter_construction: winterConstruction
                ),
                model_info: ModelInfo(
                    model_name: "로컬 계산기",
                    version: "1.0.0",
                    accuracy: 75.0,
                    training_date: "N/A"
                )
            )
            estimator.errorMessage = "ML 모델 연결 실패로 로컬 견적을 사용합니다."
        }
    }
}

#Preview {
    EstimationView()
}
