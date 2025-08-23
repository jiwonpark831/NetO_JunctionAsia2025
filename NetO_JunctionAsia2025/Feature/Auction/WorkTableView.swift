//
//  WorkTableView.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

import SwiftUI

struct WorkTableView: View {
    let data: [String: [WorkItem]]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(data.keys.sorted(), id: \.self) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        // 카테고리 제목
                        Text(category)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)
                        
                        // 헤더
                        HStack {
                            Text("코드").bold().frame(width: 100, alignment: .leading)
                            Text("명칭").bold().frame(width: 150, alignment: .leading)
                            Text("규격").bold().frame(width: 100, alignment: .leading)
                            Text("단위").bold().frame(width: 50, alignment: .leading)
                            Text("단가").bold().frame(width: 70, alignment: .trailing)
                            Text("노무비율").bold().frame(width: 70, alignment: .trailing)
                        }
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        
                        // 각 항목
                        ForEach(data[category] ?? []) { item in
                            HStack {
                                Text(item.공종코드).frame(width: 100, alignment: .leading)
                                Text(item.공종명칭).frame(width: 150, alignment: .leading)
                                Text(item.규격).frame(width: 100, alignment: .leading)
                                Text(item.단위).frame(width: 50, alignment: .leading)
                                Text("\(item.단가)").frame(width: 70, alignment: .trailing)
                                Text(item.노무비율).frame(width: 70, alignment: .trailing)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
