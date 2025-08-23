//
//  WorkItem.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

//Json 파일 처리
import SwiftUI

struct WorkItem: Codable, Identifiable {
    var id: String { 공종코드 } // 공종코드를 unique id로 사용
    let 공종코드: String
    let 공종명칭: String
    let 규격: String
    let 단위: String
    let 단가: Int
    let 노무비율: String
}

func loadWorkItems(from fileName: String) -> [String: [WorkItem]] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return [:]
    }
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let result = try decoder.decode([String: [WorkItem]].self, from: data)
        return result
    } catch {
        return [:]
    }
}

