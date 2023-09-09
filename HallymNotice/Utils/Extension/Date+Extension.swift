//
//  Date+Extension.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation

extension Date {
    static func todayDateString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: now)
    }
}
