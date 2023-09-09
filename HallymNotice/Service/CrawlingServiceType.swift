//
//  CrawlingServiceType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation
import Combine

protocol CrawlingServiceType {
    var noticePublisher: AnyPublisher<[Notice], Never> { get }
    
    func noticeCrawl(page: Int)
}
