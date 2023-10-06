//
//  Menu.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/15.
//

import UIKit

enum Menu: String, CaseIterable {
    case receiveNewNotice = "새 공지 알림"
    case keywords = "알림 키워드 편집" // 등록한 키워드
    case notification = "앱 권한 설정"
    case privacyPolicy = "개인정보처리방침"
    
    var image: UIImage? {
        switch self {
        case .receiveNewNotice:
            return UIImage(systemName: "bell.fill")
        case .notification:
            return UIImage(systemName: "gearshape.fill")
        case .keywords:
            return UIImage(systemName: "slider.vertical.3")
        case .privacyPolicy:
            return UIImage(systemName: "hand.raised.fill")
        }
    }
    
    var imageBackgroundColor: UIColor? {
        switch self {
        case .receiveNewNotice:
            return .systemYellow
        case .notification:
            return ThemeColor.gray
        case .keywords:
            return .systemIndigo
        case .privacyPolicy:
            return .systemBlue
        }
    }
}
