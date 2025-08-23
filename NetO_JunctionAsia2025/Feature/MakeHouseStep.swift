//
//  MakeHouseView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//  사용자 입력값 받는 뷰

import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

enum MakeHouseStep: Int, CaseIterable {
    case size
    case floor_count
    case room_count
    case bathroom_count
    case construction_type
    case material_grade
    case soil_condition
    case access_condition
    case noise_restriction
    case pump_truck_restriction
    case urban_area
    case winter_construction

    var totalSteps: Int {
        return MakeHouseStep.allCases.count
    }

    var title: String {
        switch self {
        case .size: "집의 크기는 몇 평으로 할까요?"
        case .floor_count: "몇 층으로 지을까요?"
        case .room_count: "방은 몇 개가 필요한가요?"
        case .bathroom_count: "화장실은 몇 개가 필요한가요?"
        case .construction_type: "어떤 건축 공법을 원하시나요?"
        case .material_grade: "자재 등급을 선택해주세요."
        case .soil_condition: "대지의 지반 상태는 어떤가요?"
        case .access_condition: "공사 차량의 진입 여건은 어떤가요?"
        case .noise_restriction: "소음 제한이 있는 지역인가요?"
        case .pump_truck_restriction: "펌프카 사용에 제한이 있나요?"
        case .urban_area: "도심지에 해당하나요?"
        case .winter_construction: "동절기 공사가 필요한가요?"
        }
    }
}

class MakeHouseStepData: ObservableObject, Codable {

    enum CodingKeys: String, CodingKey {
        case size, floor_count, room_count, bathroom_count, construction_type,
            material_grade, soil_condition, access_condition, noise_restriction,
            pump_truck_restriction, urban_area, winter_construction
    }

    @Published var size: Int = 0
    @Published var floor_count: Int = 0
    @Published var room_count: Int = 0
    @Published var bathroom_count: Int = 0
    @Published var construction_type: String = ""
    @Published var material_grade: String = ""
    @Published var soil_condition: String = ""
    @Published var access_condition: String = ""
    @Published var noise_restriction: Bool? = nil
    @Published var pump_truck_restriction: Bool? = nil
    @Published var urban_area: Bool? = nil
    @Published var winter_construction: Bool? = nil

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Int.self, forKey: .size)
        floor_count = try container.decode(Int.self, forKey: .floor_count)
        room_count = try container.decode(Int.self, forKey: .room_count)
        bathroom_count = try container.decode(
            Int.self,
            forKey: .bathroom_count
        )
        construction_type = try container.decode(
            String.self,
            forKey: .construction_type
        )
        material_grade = try container.decode(
            String.self,
            forKey: .material_grade
        )
        soil_condition = try container.decode(
            String.self,
            forKey: .soil_condition
        )
        access_condition = try container.decode(
            String.self,
            forKey: .access_condition
        )
        noise_restriction = try container.decodeIfPresent(
            Bool.self,
            forKey: .noise_restriction
        )
        pump_truck_restriction = try container.decodeIfPresent(
            Bool.self,
            forKey: .pump_truck_restriction
        )
        urban_area = try container.decodeIfPresent(
            Bool.self,
            forKey: .urban_area
        )
        winter_construction = try container.decodeIfPresent(
            Bool.self,
            forKey: .winter_construction
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try container.encode(floor_count, forKey: .floor_count)
        try container.encode(room_count, forKey: .room_count)
        try container.encode(bathroom_count, forKey: .bathroom_count)
        try container.encode(construction_type, forKey: .construction_type)
        try container.encode(material_grade, forKey: .material_grade)
        try container.encode(soil_condition, forKey: .soil_condition)
        try container.encode(access_condition, forKey: .access_condition)
        try container.encodeIfPresent(
            noise_restriction,
            forKey: .noise_restriction
        )
        try container.encodeIfPresent(
            pump_truck_restriction,
            forKey: .pump_truck_restriction
        )
        try container.encodeIfPresent(urban_area, forKey: .urban_area)
        try container.encodeIfPresent(
            winter_construction,
            forKey: .winter_construction
        )
    }
    init() {}
}

struct MakeHouseView: View {
    @State private var currentStep: MakeHouseStep = .size
    @StateObject private var stepData = MakeHouseStepData()
    @StateObject private var estimator = ConstructionEstimator()
    @State private var showEstimation = false
    @State private var navigateToSummary = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 커스텀 상단 바
                HStack {
                    Button(action: goToPreviousStep) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("이전")
                        }
                        .foregroundColor(.jaorange)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ProgressView(
                    value: Double(currentStep.rawValue + 1),
                    total: Double(currentStep.totalSteps)
                )
                .tint(.jaorange)

                Text("\(currentStep.rawValue + 1) / \(currentStep.totalSteps)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                stepView(for: currentStep)
                    .id(currentStep)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        )
                    )



                Spacer()

                navigationButtons
                    .padding()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func stepView(for step: MakeHouseStep) -> some View {
        Group {
            switch step {
            case .size:
                NumberInputView(
                    title: step.title,
                    value: $stepData.size,
                    unit: "평"
                )
            case .floor_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.floor_count,
                    unit: "층"
                )
            case .room_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.room_count,
                    unit: "개"
                )
            case .bathroom_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.bathroom_count,
                    unit: "개"
                )
            case .construction_type:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.construction_type,
                    options: ["철근콘크리트", "철골철근콘크리트", "철골조", "순철골", "목재구조", "벽돌구조", "경량철골"]
                )
            case .material_grade:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.material_grade,
                    options: ["기본", "중급", "고급", "프리미엄"]
                )
            case .soil_condition:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.soil_condition,
                    options: ["보통", "연약", "양호"]
                )
            case .access_condition:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.access_condition,
                    options: ["양호", "보통", "제한적", "매우제한적"]
                )
            case .noise_restriction, .pump_truck_restriction, .urban_area,
                .winter_construction:
                BooleanInputView(
                    title: step.title,
                    selection: binding(for: step)
                )
            }
        }
        .environmentObject(stepData)
    }

    private func binding(for step: MakeHouseStep) -> Binding<Bool?> {
        switch step {
        case .noise_restriction: return $stepData.noise_restriction
        case .pump_truck_restriction: return $stepData.pump_truck_restriction
        case .urban_area: return $stepData.urban_area
        case .winter_construction: return $stepData.winter_construction
        default: return .constant(nil)
        }
    }

    @ViewBuilder
    private var navigationButtons: some View {
        HStack {
            if currentStep.rawValue < currentStep.totalSteps - 1 {
                Button(action: goToNextStep) {
                    Text("다음")
                        .padding()
                        .frame(maxWidth: 128, maxHeight: 49)
                        .background(.jaorange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                VStack(spacing: 10) {
                    if estimator.estimation != nil {
                        NavigationLink(
                            destination: SummaryView()
                                .environmentObject(stepData)
                                .environmentObject(estimator),
                            isActive: $navigateToSummary
                        ) {
                            Text("결과 보기")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.jaorange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: calculateEstimation) {
                            HStack {
                                if estimator.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "function")
                                }
                                Text(estimator.isLoading ? "계산 중..." : "결과 보러가기")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.jaorange)
                            .cornerRadius(10)
                        }
                        .disabled(estimator.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                }
            }
        }
    }

    private var isFormValid: Bool {
        stepData.size > 0 && stepData.floor_count > 0 && stepData.room_count > 0 && 
        stepData.bathroom_count > 0 && !stepData.construction_type.isEmpty && 
        !stepData.material_grade.isEmpty && !stepData.soil_condition.isEmpty && 
        !stepData.access_condition.isEmpty
    }

    private func goToNextStep() {
        guard let nextStep = MakeHouseStep(rawValue: currentStep.rawValue + 1)
        else { return }
        withAnimation {
            currentStep = nextStep
        }
    }

    private func goToPreviousStep() {
        if currentStep.rawValue > 0 {
            // 이전 단계로 이동
            guard let prevStep = MakeHouseStep(rawValue: currentStep.rawValue - 1)
            else { return }
            withAnimation {
                currentStep = prevStep
            }
        } else {
            // 첫 화면이면 이전 화면으로 돌아가기
            dismiss()
        }
    }
    
    private func calculateEstimation() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: Date())
        
        // 조건 태그 생성 (EstimationView와 동일)
        var conditionTags: [String] = []
        if stepData.urban_area == true { conditionTags.append("도심") }
        if stepData.pump_truck_restriction == true { conditionTags.append("펌프카제한") }
        if stepData.noise_restriction == true { conditionTags.append("소음규제") }
        if stepData.soil_condition == "연약" { conditionTags.append("지반연약") }
        if stepData.access_condition == "양호" { conditionTags.append("장비양호") }
        
        let request = EstimationRequest(
            startDate: startDateString,
            size: stepData.size,
            floor_count: stepData.floor_count,
            room_count: stepData.room_count,
            bathroom_count: stepData.bathroom_count,
            construction_type: stepData.construction_type,
            material_grade: stepData.material_grade,
            soil_condition: stepData.soil_condition,
            conditionTags: conditionTags,
            accessCondition: stepData.access_condition,
            noiseRestriction: stepData.noise_restriction ?? false,
            pumpTruckRestriction: stepData.pump_truck_restriction ?? false,
            urbanArea: stepData.urban_area ?? false,
            winterConstruction: stepData.winter_construction ?? false
        )
        
        // ML 모델 호출 시도
        Task {
            do {
                try await estimator.estimate(request)
                await MainActor.run {
                    showEstimation = true
                    // 계산 완료 후 자동으로 결과 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        navigateToSummary = true
                    }
                }
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
                    area: stepData.size,
                    floors: stepData.floor_count,
                    construction_type: stepData.construction_type,
                    location: "로컬",
                    complexity: "보통",
                    material_grade: stepData.material_grade,
                    access_condition: stepData.access_condition,
                    noise_restriction: stepData.noise_restriction,
                    pump_truck_restriction: stepData.pump_truck_restriction,
                    urban_area: stepData.urban_area,
                    winter_construction: stepData.winter_construction
                ),
                model_info: ModelInfo(
                    model_name: "로컬 계산기",
                    version: "1.0.0",
                    accuracy: 75.0,
                    training_date: "N/A"
                )
            )
            showEstimation = true
            // 로컬 견적 계산 완료 후 자동으로 결과 화면으로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                navigateToSummary = true
            }
        }
    }
}

struct NumberInputView: View {
    let title: String
    @Binding var value: Int
    let unit: String
    @State private var textValue: String = ""

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            HStack {
                TextField("숫자 입력", text: $textValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .onAppear {
                        // 초기값이 0이면 빈 문자열로 표시
                        textValue = value == 0 ? "" : "\(value)"
                    }
                    .onChange(of: textValue) { newValue in
                        // 텍스트가 변경될 때마다 Int 값 업데이트
                        if let intValue = Int(newValue) {
                            value = intValue
                        } else if newValue.isEmpty {
                            value = 0
                        }
                    }
                Text(unit)
                    .font(.headline)
            }
            .padding(.horizontal, 50)
        }
        .padding()
    }
}

struct StringInputView: View {
    let title: String
    @Binding var value: String
    let unit: String

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            HStack {
                TextField("입력", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title)
                Text(unit)
                    .font(.headline)
            }
            .padding(.horizontal, 50)
        }
        .padding()
    }
}

struct PickerInputView: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // 이미지처럼 하나의 컨테이너 안에 버튼들을 배치
            VStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        HStack {
                            Text(option)
                                .font(.body)
                                .foregroundColor(selection == option ? .white : .primary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(selection == option ? .jaorange : Color.clear)
                        .cornerRadius(0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // 마지막 버튼이 아닌 경우 구분선 추가
                    if option != options.last {
                        Divider()
                            .background(Color(.systemGray4))
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .padding()
    }
}

struct BooleanInputView: View {
    let title: String
    @Binding var selection: Bool?

    private enum BoolOption: Int, CaseIterable, Identifiable {
        case yes, no, unknown
        var id: Int { rawValue }

        var title: String {
            switch self {
            case .yes: return "예"
            case .no: return "아니오"
            case .unknown: return "모름"
            }
        }

        var boolValue: Bool? {
            switch self {
            case .yes: return true
            case .no: return false
            case .unknown: return nil
            }
        }
    }

    @State private var pickerSelection: BoolOption

    init(title: String, selection: Binding<Bool?>) {
        self.title = title
        self._selection = selection

        if let value = selection.wrappedValue {
            _pickerSelection = State(initialValue: value ? .yes : .no)
        } else {
            _pickerSelection = State(initialValue: .unknown)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Picker(title, selection: $pickerSelection) {
                ForEach(BoolOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: pickerSelection) { newValue in
                selection = newValue.boolValue
            }
        }
        .padding()
    }
}

struct SummaryView: View {
    @EnvironmentObject var stepData: MakeHouseStepData
    @EnvironmentObject var estimator: ConstructionEstimator
    @State private var isSaving = false
    @State private var alertMessage: String?
    @State private var showAlert = false
    @StateObject private var manager = GoogleSignInManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("입력하신 정보는 다음과 같습니다.")
                    .font(.title2).bold()
                    .padding(.bottom, 10)

                Group {
                    SummaryRow(label: "크기", value: "\(stepData.size) 평")
                    SummaryRow(label: "층수", value: "\(stepData.floor_count) 층")
                    SummaryRow(label: "방 개수", value: "\(stepData.room_count) 개")
                    SummaryRow(
                        label: "화장실 개수",
                        value: "\(stepData.bathroom_count) 개"
                    )
                    SummaryRow(
                        label: "건축 공법",
                        value: stepData.construction_type
                    )
                    SummaryRow(label: "자재 등급", value: stepData.material_grade)
                    SummaryRow(label: "지반 상태", value: stepData.soil_condition)
                    SummaryRow(label: "진입 여건", value: stepData.access_condition)
                    SummaryRow(
                        label: "소음 제한",
                        value: boolToString(stepData.noise_restriction)
                    )
                    SummaryRow(
                        label: "펌프카 제한",
                        value: boolToString(stepData.pump_truck_restriction)
                    )
                    SummaryRow(
                        label: "도심지",
                        value: boolToString(stepData.urban_area)
                    )
                    SummaryRow(
                        label: "동절기 공사",
                        value: boolToString(stepData.winter_construction)
                    )
                }

                Spacer(minLength: 30)
                
                // 견적 결과 표시
                if let estimation = estimator.estimation {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("견적 결과")
                            .font(.title2).bold()
                            .padding(.bottom, 10)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("예상 공사 비용")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(estimation.predictions.total_cost_krw)원")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.jaorange)
                            }
                            
                            HStack {
                                Text("예상 공사 기간")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(estimation.predictions.total_duration_days)일")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.jayellow)
                            }
                            
                            if let modelInfo = estimation.model_info {
                                HStack {
                                    Text("계산 방식")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(modelInfo.model_name ?? "알 수 없음")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                } else {
                    // 견적이 계산되지 않은 경우 안내 메시지
                    VStack(alignment: .leading, spacing: 15) {
                        Text("견적 계산이 필요합니다")
                            .font(.title2).bold()
                            .padding(.bottom, 10)
                        
                        Text("정확한 견적을 위해 '견적 계산' 버튼을 먼저 눌러주세요.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // 오류 메시지 표시
                if let errorMessage = estimator.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                Button(action: saveToFirebase) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("입찰하러가기")
                    }
                }
                .disabled(isSaving)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSaving ? Color.gray : .jaorange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("요약 및 저장")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage ?? ""),
                dismissButton: .default(Text("확인"))
            )
        }
    }

    private func boolToString(_ value: Bool?) -> String {
        if let value = value {
            return value ? "예" : "아니오"
        }
        return "모름"
    }

    private func saveToFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "데이터를 저장하려면 로그인이 필요합니다."
            showAlert = true
            return
        }

        isSaving = true
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)

        do {
            let houseData = try Firestore.Encoder().encode(stepData)
            
            var saveData: [String: Any] = [
                "houseData": FieldValue.arrayUnion([houseData]),
                "timestamp": FieldValue.serverTimestamp()
            ]
            
            // 견적 결과가 있으면 함께 저장
            if let estimation = estimator.estimation {
                let estimationData = try Firestore.Encoder().encode(estimation)
                saveData["estimationData"] = FieldValue.arrayUnion([estimationData])
            }

            userDocRef.setData(saveData, merge: true) { error in
                isSaving = false
                if let error = error {
                    alertMessage = "저장 실패: \(error.localizedDescription)"
                } else {
                    alertMessage = "성공적으로 저장되었습니다!"
                }
                showAlert = true
            }
        } catch let error {
            isSaving = false
            alertMessage = "데이터 저장 실패: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        Divider()
    }
}

struct MakeMyHouseView_Previews: PreviewProvider {
    static var previews: some View {
        MakeHouseView()
    }
}
