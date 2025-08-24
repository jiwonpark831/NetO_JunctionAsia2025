//
//  MakeHouseView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

// ✅ CapsuleSegmentedControl 추가
struct CapsuleSegmentedControl: View {
    let options: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    Text(option)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(
                            selection == option ? .jaorange : .gray
                        )
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(
                            ZStack {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.white)
                                        .shadow(
                                            color: Color.black.opacity(0.1),
                                            radius: 4,
                                            x: 0,
                                            y: 2
                                        )
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}

// ✅ 선택형 뷰 (PickerInputView 대체)
struct CapsulePickerInputView: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            CapsuleSegmentedControl(options: options, selection: $selection)
        }
        .padding()
    }
}

// MARK: - MakeHouseStep Enum
enum MakeHouseStep: Int, CaseIterable {
    case size, floor_count, room_count, bathroom_count
    case construction_type, material_grade, soil_condition, access_condition
    case noise_restriction, pump_truck_restriction, urban_area,
        winter_construction

    var totalSteps: Int {
        return MakeHouseStep.allCases.count
    }

    var title: String {
        switch self {
        case .size: "What is the desired size of the house (in pyeong)?"
        case .floor_count: "How many floors should the house have?"
        case .room_count: "How many rooms do you need?"
        case .bathroom_count: "How many bathrooms do you need?"
        case .construction_type: "Which construction method do you prefer?"
        case .material_grade: "Select the material grade."
        case .soil_condition: "What is the soil condition of the site?"
        case .access_condition:
            "What is the access condition for construction vehicles?"
        case .noise_restriction:
            "Is the site located in an area with noise restrictions?"
        case .pump_truck_restriction:
            "Are there any restrictions on using pump trucks?"
        case .urban_area: "Is the site located in an urban area?"
        case .winter_construction:
            "Will construction be carried out during the winter?"
        }
    }
}

// MARK: - MakeHouseStepData
class MakeHouseStepData: ObservableObject, Codable {

    enum CodingKeys: String, CodingKey {
        case size, floor_count, room_count, bathroom_count, construction_type,
            material_grade, soil_condition, access_condition, noise_restriction,
            pump_truck_restriction, urban_area, winter_construction,
            noise_restriction_string, pump_truck_restriction_string,
            urban_area_string, winter_construction_string
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

    // 9번부터 12번까지의 문자열 속성들 (UI용)
    @Published var noise_restriction_string: String = "I don't know"
    @Published var pump_truck_restriction_string: String = "I don't know"
    @Published var urban_area_string: String = "I don't know"
    @Published var winter_construction_string: String = "I don't know"

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
        noise_restriction_string =
            try container.decodeIfPresent(
                String.self,
                forKey: .noise_restriction_string
            ) ?? "I don't know"
        pump_truck_restriction_string =
            try container.decodeIfPresent(
                String.self,
                forKey: .pump_truck_restriction_string
            ) ?? "I don't know"
        urban_area_string =
            try container.decodeIfPresent(
                String.self,
                forKey: .urban_area_string
            ) ?? "I don't know"
        winter_construction_string =
            try container.decodeIfPresent(
                String.self,
                forKey: .winter_construction_string
            ) ?? "I don't know"
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
        try container.encode(
            noise_restriction_string,
            forKey: .noise_restriction_string
        )
        try container.encode(
            pump_truck_restriction_string,
            forKey: .pump_truck_restriction_string
        )
        try container.encode(urban_area_string, forKey: .urban_area_string)
        try container.encode(
            winter_construction_string,
            forKey: .winter_construction_string
        )
    }
    init() {
        noise_restriction_string = "I don't know"
        pump_truck_restriction_string = "I don't know"
        urban_area_string = "I don't know"
        winter_construction_string = "I don't know"
    }

    // Bool 값이 변경될 때 문자열 값도 동기화
    func syncStringValues() {
        if let noise = noise_restriction {
            noise_restriction_string = noise ? "Yes" : "No"
        }
        if let pump = pump_truck_restriction {
            pump_truck_restriction_string = pump ? "Yes" : "No"
        }
        if let urban = urban_area {
            urban_area_string = urban ? "Yes" : "No"
        }
        if let winter = winter_construction {
            winter_construction_string = winter ? "Yes" : "No"
        }
    }
}

// MARK: - MakeHouseView
struct MakeHouseView: View {
    @State private var currentStep: MakeHouseStep = .size
    @StateObject private var stepData = MakeHouseStepData()
    @StateObject private var estimator = ConstructionEstimator()
    @State private var showEstimation = false
    @State private var navigateToSummary = false
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 상단 바
                HStack {
                    Button(action: goToPreviousStep) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Back")
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
            .onAppear {
                stepData.syncStringValues()
            }
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
                    unit: "pyeong"
                )
            case .floor_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.floor_count,
                    unit: " "
                )
            case .room_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.room_count,
                    unit: " "
                )
            case .bathroom_count:
                NumberInputView(
                    title: step.title,
                    value: $stepData.bathroom_count,
                    unit: " "
                )
            case .construction_type:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.construction_type,
                    options: [
                        "Lightweight wooden structure", "Reinforced concrete",
                        "Steelhouse",
                    ]
                )
            case .material_grade:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.material_grade,
                    options: ["Standard", "Mid-range", "High-end", "Premium"]
                )
            case .soil_condition:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.soil_condition,
                    options: ["Normal", "Weak", "Good"]
                )
            case .access_condition:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.access_condition,
                    options: ["Good", "Normal", "Limited", "Very Limited"]
                )
            case .noise_restriction:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.noise_restriction_string,
                    options: ["Yes", "No", "I don't know"]
                )
                .onChange(of: stepData.noise_restriction_string) { newValue in
                    stepData.noise_restriction =
                        newValue == "Yes"
                        ? true : (newValue == "No" ? false : nil)
                }
            case .pump_truck_restriction:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.pump_truck_restriction_string,
                    options: ["Yes", "No", "I don't know"]
                )
                .onChange(of: stepData.pump_truck_restriction_string) {
                    newValue in
                    stepData.pump_truck_restriction =
                        newValue == "Yes"
                        ? true : (newValue == "I don't know" ? false : nil)
                }
            case .urban_area:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.urban_area_string,
                    options: ["Yes", "No", "I don't know"]
                )
                .onChange(of: stepData.urban_area_string) { newValue in
                    stepData.urban_area =
                        newValue == "Yes"
                        ? true : (newValue == "No" ? false : nil)
                }
            case .winter_construction:
                CapsulePickerInputView(
                    title: step.title,
                    selection: $stepData.winter_construction_string,
                    options: ["Yes", "No", "I don't know"]
                )
                .onChange(of: stepData.winter_construction_string) { newValue in
                    stepData.winter_construction =
                        newValue == "Yes"
                        ? true : (newValue == "No" ? false : nil)
                }
            }
        }
        .environmentObject(stepData)
    }

    @ViewBuilder
    private var navigationButtons: some View {
        HStack {
            if currentStep.rawValue < currentStep.totalSteps - 1 {
                Button(action: goToNextStep) {
                    Text("Next")
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
                            destination: SummaryView(isPresented: $isPresented)
                                .environmentObject(stepData)
                                .environmentObject(estimator),
                            isActive: $navigateToSummary
                        ) {
                            Text("Get result")
                                .padding()
                                .frame(maxWidth: 128, maxHeight: 49)
                                .background(.jaorange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: calculateEstimation) {
                            HStack(spacing: 8) {
                                if estimator.isLoading {
                                    ProgressView()
                                        .progressViewStyle(
                                            CircularProgressViewStyle(
                                                tint: .white
                                            )
                                        )
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "function")
                                        .font(
                                            .system(size: 16, weight: .medium)
                                        )
                                }
                                Text(
                                    estimator.isLoading
                                        ? "Calculating..." : "Get result"
                                )
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: 128, maxHeight: 49)
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
        stepData.size > 0 && stepData.floor_count > 0 && stepData.room_count > 0
            && stepData.bathroom_count > 0
            && !stepData.construction_type.isEmpty
            && !stepData.material_grade.isEmpty
            && !stepData.soil_condition.isEmpty
            && !stepData.access_condition.isEmpty
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
            guard
                let prevStep = MakeHouseStep(rawValue: currentStep.rawValue - 1)
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

        // 조건 태그 생성
        var conditionTags: [String] = []
        if stepData.urban_area == true { conditionTags.append("도심") }
        if stepData.pump_truck_restriction == true {
            conditionTags.append("펌프카제한")
        }
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
                                location: "Local",
            complexity: "Normal",
                    material_grade: stepData.material_grade,
                    access_condition: stepData.access_condition,
                    noise_restriction: stepData.noise_restriction,
                    pump_truck_restriction: stepData.pump_truck_restriction,
                    urban_area: stepData.urban_area,
                    winter_construction: stepData.winter_construction
                ),
                model_info: ModelInfo(
                    model_name: "Local Calculator",
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
                TextField("Enter a number", text: $textValue)
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
                TextField("Enter", text: $value)
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

struct SegmentedButtonView: View {
    let options: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    Text(option)
                        .font(.body)
                        .foregroundColor(
                            selection == option ? .jaorange : .secondary
                        )
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(
                                    selection == option
                                        ? Color.white : Color.clear
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(
                                    Color(.systemGray4),
                                    lineWidth: selection == option ? 0 : 1
                                )
                        )
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .cornerRadius(25)
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
            case .yes: return "Yes"
            case .no: return "No"
            case .unknown: return "I don't know"
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

    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Your information")
                    .font(.title2).bold()
                    .padding(.bottom, 10)

                Group {
                    SummaryRow(label: "Size", value: "\(stepData.size) Pyeong")
                    SummaryRow(
                        label: "Floor",
                        value: "\(stepData.floor_count) "
                    )
                    SummaryRow(
                        label: "Number of rooms",
                        value: "\(stepData.room_count) "
                    )
                    SummaryRow(
                        label: "Number of bathrooms",
                        value: "\(stepData.bathroom_count)"
                    )
                    SummaryRow(
                        label: "Construction type",
                        value: stepData.construction_type
                    )
                    SummaryRow(
                        label: "Material grade",
                        value: stepData.material_grade
                    )
                    SummaryRow(
                        label: "Soil condition",
                        value: stepData.soil_condition
                    )
                    SummaryRow(
                        label: "Access condition",
                        value: stepData.access_condition
                    )
                    SummaryRow(
                        label: "Noise restriction",
                        value: stepData.noise_restriction_string
                    )
                    SummaryRow(
                        label: "Pump truck restriction",
                        value: stepData.pump_truck_restriction_string
                    )
                    SummaryRow(
                        label: "Urban area",
                        value: stepData.urban_area_string
                    )
                    SummaryRow(
                        label: "Winter construction",
                        value: stepData.winter_construction_string
                    )
                }

                Spacer(minLength: 30)

                // 견적 결과 표시
                if let estimation = estimator.estimation {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Estimate Result")
                            .font(.title2).bold()
                            .padding(.bottom, 10)

                        VStack(spacing: 12) {
                            HStack {
                                Text("Cost Estimate")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(
                                    "\(estimation.predictions.total_cost_krw) Won"
                                )
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.jaorange)
                            }

                            HStack {
                                Text("Estimated Duration")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(
                                    "\(estimation.predictions.total_duration_days) Days"
                                )
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.jayellow)
                            }

                            if let modelInfo = estimation.model_info {
                                HStack {
                                    Text("Estimation Model")
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
                        Text("Estimation calculation is required")
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
                        Text("Save")
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
        .navigationTitle("Summary & Save")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alarm"),
                message: Text(alertMessage ?? ""),
                dismissButton: .default(Text("Confirm")) {
                    if alertMessage == "Save succeeded" {
                        self.isPresented = false
                    }
                }
            )
        }
    }

    private func boolToString(_ value: Bool?) -> String {
        if let value = value {
            return value ? "Yes" : "No"
        }
        return "I don't know"
    }

    private func stringToBool(_ value: String) -> Bool? {
        switch value {
        case "Yes": return true
        case "No": return false
        default: return nil
        }
    }

    private func saveToFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "Login is required to save data."
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
                "timestamp": FieldValue.serverTimestamp(),
            ]

            // 견적 결과가 있으면 함께 저장
            if let estimation = estimator.estimation {
                let estimationData = try Firestore.Encoder().encode(estimation)
                saveData["estimationData"] = FieldValue.arrayUnion([
                    estimationData
                ])
            }

            userDocRef.setData(saveData, merge: true) { error in
                isSaving = false
                if let error = error {
                    alertMessage = "Save failed: \(error.localizedDescription)"
                } else {
                    alertMessage = "Save succeeded"
                }
                showAlert = true
            }
        } catch let error {
            isSaving = false
            alertMessage = "Data save failed: \(error.localizedDescription)"
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
