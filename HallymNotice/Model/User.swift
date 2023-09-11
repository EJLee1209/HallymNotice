//
//  User.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import Foundation

struct User: Codable {
    let fcmToken: String // FCM 토큰
    var keywords: [String] // 알림 키워드
    var isNewNoticeReceiveNotify: Bool // 새 공지사항 알림 여부
}
