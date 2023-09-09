//
//  Notice.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation

struct Notice: Hashable {
    let id: Int
    let title: String
    let writer: String
    let publishDate: String
    let detailLink: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        return lhs.id == rhs.id
    }
}
