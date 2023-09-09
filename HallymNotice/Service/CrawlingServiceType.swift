//
//  CrawlingServiceType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation
import Combine

protocol CrawlingServiceType {
    
    func noticeCrawl(page: Int, keyword: String?) -> AnyPublisher<[Notice], Never>
    
}
