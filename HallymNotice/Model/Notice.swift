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
    
    private let identifier: String = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
