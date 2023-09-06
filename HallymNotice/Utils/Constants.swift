//
//  Constants.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import Foundation

struct Constants {
    
    //MARK: - String Resource
    static let welcomeTitle1 = "만나서 반가워요."
    static let welcomeSubTitle1 = "\n알림 키워드를 등록하고,\n새로운 공지사항 알림을 받아보세요!"
    static let welcomeAdvice = "1개 이상 선택 필수 (나중에 바꿀 수 있어요!)"
    static let inputPlaceHolder = "직접 입력해서 추가"
    
    static let welcomeTitle2 = "새 공지가 올라왔을 때,"
    static let welcomeSubTitle2 = "\n알림을 받으시겠어요?"
    
    static let welcomeTitle3 = "모든 설정이 끝났어요."
    
    static let welcomeNoticePositiveButtonText = "네, 알림 받을래요!"
    static let welcomeNoticeNegativeButtonText = "아니요, 키워드 알림만 받을게요"
    
    
    //MARK: - Cell Identifier
    static let keywordCellIdentifier = "keywordCell"
    static let weatherCellIdentifier = "weatherCell"
    
    //MARK: - dummy data
    static let defaultKeywords: [Keyword] = [
        Keyword(text: "장학금", isSelected: false),
        Keyword(text: "등록금", isSelected: false),
        Keyword(text: "진로", isSelected: false),
        Keyword(text: "근로", isSelected: false),
        Keyword(text: "인턴", isSelected: false),
        Keyword(text: "취업", isSelected: false),
        Keyword(text: "병무청", isSelected: false),
        Keyword(text: "버스", isSelected: false),
    ]
}
