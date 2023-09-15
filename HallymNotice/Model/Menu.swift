//
//  Menu.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/15.
//

import UIKit

enum Menu: String, CaseIterable {
    case notification = "앱 권한 설정"
    case keywords = "알림 키워드 편집" // 등록한 키워드
    case talkToDeveloper = "개발자에게 한마디"
    case privacyPolicy = "개인정보처리방침"
    
    var image: UIImage? {
        switch self {
        case .notification:
            return UIImage(systemName: "gearshape.fill")
        case .keywords:
            return UIImage(systemName: "bell.fill")
        case .talkToDeveloper:
            return UIImage(systemName: "paperplane.fill")
        case .privacyPolicy:
            return UIImage(systemName: "hand.raised.fill")
        }
    }
    
    var imageBackgroundColor: UIColor? {
        switch self {
        case .notification:
            return ThemeColor.gray
        case .keywords:
            return .systemYellow
        case .talkToDeveloper:
            return ThemeColor.primary
        case .privacyPolicy:
            return .systemBlue
        }
    }
}
