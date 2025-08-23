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
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        
        var result: [String: [WorkItem]] = [:]
        
        for (section, value) in jsonObject {
            // Case 1: value가 배열인 경우 (basic)
            if let itemsArray = value as? [[String: Any]] {
                let itemsData = try JSONSerialization.data(withJSONObject: itemsArray)
                let decodedItems = try JSONDecoder().decode([WorkItem].self, from: itemsData)
                result[section] = decodedItems
            }
            // Case 2: value가 딕셔너리인 경우 (bone, facility, final)
            else if let sectionDict = value as? [String: Any] {
                // 바로 "항목" 있는 경우
                if let itemsArray = sectionDict["항목"] as? [[String: Any]] {
                    let itemsData = try JSONSerialization.data(withJSONObject: itemsArray)
                    let decodedItems = try JSONDecoder().decode([WorkItem].self, from: itemsData)
                    result[section] = decodedItems
                }
                
                // 한 단계 더 깊이 들어가 "항목" 있는 경우
                for (subKey, subValue) in sectionDict {
                    if let subDict = subValue as? [String: Any],
                       let itemsArray = subDict["항목"] as? [[String: Any]] {
                        let itemsData = try JSONSerialization.data(withJSONObject: itemsArray)
                        let decodedItems = try JSONDecoder().decode([WorkItem].self, from: itemsData)
                        result["\(section) - \(subKey)"] = decodedItems
                    }
                }
            }
        }
        
        return result
    } catch {
        print("❌ JSON parse error in \(fileName): \(error)")
        return [:]
    }
}
