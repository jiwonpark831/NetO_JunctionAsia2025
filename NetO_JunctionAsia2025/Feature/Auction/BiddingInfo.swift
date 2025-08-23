//
//  BiddingInfo.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//


import Foundation

struct BiddingInfo: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let address: String
    let contact: String
    let status: String
    let startDate: String
    let endDate: String
    let description: String
    
    // 샘플 데이터
    static let sample = BiddingInfo(
        category: "Foundation Work",
        title: "Excavation",
        address: "XXX-XX0, Gyeongsangbuk-do",
        contact: "010-XXXX-XXXX",
        status: "before proceeding",
        startDate: "2025.09.01",
        endDate: "2025.12.31",
        description: "Large-scale excavation project for commercial building foundation"
    )
}
