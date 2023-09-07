//
//  String+.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation

extension String {
    
    func makeFormattedDate(date: Date?) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        formatter.dateFormat = self
        
        guard let date = date else { return nil }
        return formatter.string(from: date)
    }
    
    
}
