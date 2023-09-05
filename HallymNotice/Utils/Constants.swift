//
//  Constants.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import Foundation

struct Constants {
    
    static let welcomeTitle1 = "만나서 반가워요."
    static let welcomeSubTitle1 = "\n알림 키워드를 등록하고,\n새로운 공지사항 알림을 받아보세요!"
    static let welcomeAdvice = "1개 이상 선택 필수 (나중에 바꿀 수 있어요!)"
    static let inputPlaceHolder = "직접 입력해서 추가"
    
    static let welcomeTitle2 = "새 공지가 올라왔을 때,"
    static let welcomeSubTitle2 = "알림을 받으시겠어요?"
    
    static let welcomeTitle3 = "모든 설정이 끝났어요."
    static let welcomeSubTitle3 = "N개 키워드 등록,\n새 공지 알림 O\n\n공지 사항을 놓치지 않게 해드릴게요."

    static let keywordCellIdentifier = "keywordCell"
    
    static let defaultKeywords: [String] = [
        "장학금", "등록금", "진로", "근로", "인턴", "취업", "병무청"
    ]
}
