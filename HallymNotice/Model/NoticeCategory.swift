//
//  NoticeCategory.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/19.
//

import Foundation

enum NoticeCategory: String, CaseIterable {
    case all = "전체" // ""
    case academic = "학사/학적/휴・복학" // 1
    case scholarships = "장학/등록/증명" // 2
    case employment = "취업/인턴쉽" // 5
    case events = "행사안내" // 4
    case generalAnnouncements = "일반공지" // 3
    case offCampusAnnouncements = "교외공지" // 7
    case covid = "코로나19" // 10382
    
    var id: String {
        switch self {
        case .all:
            return ""
        case .academic:
            return "1"
        case .scholarships:
            return "2"
        case .employment:
            return "5"
        case .events:
            return "4"
        case .generalAnnouncements:
            return "3"
        case .offCampusAnnouncements:
            return "7"
        case .covid:
            return "10382"
        }
    }
}
