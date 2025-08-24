//
//  CompanyProfileCard.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

struct CompanyProfile: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let address: String
    let contact: String
    let rating: Int
    //    let Image: String
    let startDate: Date
    let endDate: Date
}

struct CompanyProfileCard: View {
    let profile: CompanyProfile

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private func addPlanToFirebase() {
        let newPlan = Plan(
            planName: profile.name,
            startDate: profile.startDate,
            endDate: profile.endDate
        )

        ScheduleManager.shared.addPlan(plan: newPlan) { error in
            if let error = error {
                self.alertTitle = "저장 실패"
                self.alertMessage =
                    "일정 저장 중 오류가 발생했습니다: \(error.localizedDescription)"
            } else {
                self.alertTitle = "Schedule added"
                self.alertMessage = "'\(profile.name)' added in your schedule."
            }
            self.showAlert = true
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(profile.category)
                    .font(.caption)
                Text(profile.name)
                    .font(.headline)
                    .padding(.vertical, 1)
                Text(profile.address)
                    .font(.caption)
                Text(profile.contact)
                    .font(.caption)
                Text(
                    "\(dateFormatter.string(from: profile.startDate)) - \(dateFormatter.string(from: profile.endDate))"
                )
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(0..<profile.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }

                        .padding(.vertical, 1)

                        Button(action: {
                        }) {
                            Text("견적서 보기")
                                .font(.caption)
                                .foregroundColor(Color(hex: "FF7F17"))
                        }
                    }

                    Spacer()
                    Button(action: {
                        addPlanToFirebase()
                    }) {
                        Text("BID")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 11)
                            .background(Color(hex: "FF7F17"))
                            .cornerRadius(8)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "F9F9F9"))
        .cornerRadius(10)
    }

}

// 카테고리별 더미 데이터
extension CompanyProfile {
    static func sampleProfiles(for category: MainCategory) -> [CompanyProfile] {
        let calendar = Calendar.current
        let today = Date()

        // 각 카테고리별 더미 데이터
        let basicProfiles = [
            CompanyProfile(
                category: "Foundation Work",
                name: "JA Foundation",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 5,
                //                Image: "companyimage",
                startDate: today,
                endDate: calendar.date(byAdding: .day, value: 7, to: today)!
            ),
            CompanyProfile(
                category: "Foundation Work",
                name: "JBaseLine Builders",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 4,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 3, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 12, to: today)!
            ),
            CompanyProfile(
                category: "Framing Construction",
                name: "JFrameWorks Ltd.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 3,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 8, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 18, to: today)!
            ),
            CompanyProfile(
                category: "Framing Construction",
                name: "Steel & Form Co.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 5,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 13, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 25, to: today)!
            ),
        ]

        let boneProfiles = [
            CompanyProfile(
                category: "Framing Construction",
                name: "JFrameWorks Ltd.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 3,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 8, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 18, to: today)!
            ),
            CompanyProfile(
                category: "Framing Construction",
                name: "Steel & Form Co.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 5,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 13, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 25, to: today)!
            ),

        ]
        let facilityProfiles = [
            CompanyProfile(
                category: "Framing Construction",
                name: "JFrameWorks Ltd.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 3,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 8, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 18, to: today)!
            ),
            CompanyProfile(
                category: "Framing Construction",
                name: "Steel & Form Co.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 5,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 13, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 25, to: today)!
            ),

        ]
        let finalProfiles = [
            CompanyProfile(
                category: "Framing Construction",
                name: "JFrameWorks Ltd.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 3,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 8, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 18, to: today)!
            ),
            CompanyProfile(
                category: "Framing Construction",
                name: "Steel & Form Co.",
                address: "address. XXX-XX0, Gyeongsangbuk-do",
                contact: "contact. 010-XXXX-XXXX",
                rating: 5,
                //                Image: "companyimage",
                startDate: calendar.date(byAdding: .day, value: 13, to: today)!,
                endDate: calendar.date(byAdding: .day, value: 25, to: today)!
            ),

        ]

        switch category {
        case .basic: return basicProfiles
        case .bone: return boneProfiles
        case .facility: return facilityProfiles
        case .final: return finalProfiles
        }

        //        switch category {
        //        case .basic:
        //            return [
        //                CompanyProfile(category: "Foundation Work", name: "JA Foundation", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage", ),
        //                CompanyProfile(category: "Foundation Work", name: "JBaseLine Builders", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 4, Image: "companyimage"),
        //            ]
        //        case .bone:
        //            return [
        //                CompanyProfile(category: "Framing Construction", name: "JFrameWorks Ltd.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 3, Image: "companyimage"),
        //                CompanyProfile(category: "Framing Construction", name: "Steel & Form Co.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
        //            ]
        //        case .facility:
        //            return [
        //                CompanyProfile(category: "Facility Construction", name: "HVAC Masters", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
        //                CompanyProfile(category: "Facility Construction", name: "Smart Building Co.", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage"),
        //            ]
        //        case .final:
        //            return [
        //                CompanyProfile(category: "Exterior / Interior", name: "Interior Pro", address: "address. XXX-XX0, Gyeongsangbuk-do", contact: "contact. 010-XXXX-XXXX", rating: 5, Image: "companyimage")
        //            ]
        //        }
    }
}

// ScheduleManager.swift

class ScheduleManager {
    static let shared = ScheduleManager()
    private let db = Firestore.firestore()

    private init() {}

    func addPlan(plan: Plan, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(
                domain: "AuthError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "사용자가 로그인되어 있지 않습니다."]
            )
            completion(error)
            return
        }

        let planData: [String: Any] = [
            "planName": plan.planName,
            "startDate": Timestamp(date: plan.startDate),
            "endDate": Timestamp(date: plan.endDate),
        ]

        let userDocRef = db.collection("users").document(userId)

        userDocRef.updateData([
            "plan": FieldValue.arrayUnion([planData])
        ]) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
