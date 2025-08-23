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

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProgressView(
                    value: Double(currentStep.rawValue + 1),
                    total: Double(currentStep.totalSteps)
                )

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
            .navigationBarTitleDisplayMode(.inline)
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
                    options: ["경량목구조", "철근콘크리트", "스틸하우스"]
                )
            case .material_grade:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.material_grade,
                    options: ["표준", "고급", "최고급"]
                )
            case .soil_condition:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.soil_condition,
                    options: ["일반", "연약지반", "암반"]
                )
            case .access_condition:
                PickerInputView(
                    title: step.title,
                    selection: $stepData.access_condition,
                    options: ["양호", "보통", "불량"]
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
            if currentStep.rawValue > 0 {
                Button("이전") {
                    goToPreviousStep()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.primary)
                .cornerRadius(10)
            }

            if currentStep.rawValue < currentStep.totalSteps - 1 {
                Button("다음") {
                    goToNextStep()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                NavigationLink(
                    destination: SummaryView().environmentObject(stepData)
                ) {
                    Text("결과 보기 및 저장")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }

    private func goToNextStep() {
        guard let nextStep = MakeHouseStep(rawValue: currentStep.rawValue + 1)
        else { return }
        withAnimation {
            currentStep = nextStep
        }
    }

    private func goToPreviousStep() {
        guard let prevStep = MakeHouseStep(rawValue: currentStep.rawValue - 1)
        else { return }
        withAnimation {
            currentStep = prevStep
        }
    }
}

struct NumberInputView: View {
    let title: String
    @Binding var value: Int
    let unit: String

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            HStack {
                TextField("숫자 입력", value: $value, format: .number)
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

            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
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

                Button(action: saveToFirebase) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Firebase에 저장하기")
                    }
                }
                .disabled(isSaving)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSaving ? Color.gray : Color.green)
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
            let data = try Firestore.Encoder().encode(stepData)

            userDocRef.setData(
                ["houseData": FieldValue.arrayUnion([data])],
                merge: true
            ) { error in
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
            alertMessage = "데이터 인코딩 실패: \(error.localizedDescription)"
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
