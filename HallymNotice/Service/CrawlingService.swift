//
//  CrawlingService.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation
import Combine
import SwiftSoup



final class CrawlingService: CrawlingServiceType {
    
    func noticeCrawl(page: Int, keyword: String?) -> AnyPublisher<[Notice], Never> {
        
        let urlString = "\(Constants.hallymEndpoint)&pageIndex=\(page)&searchType=0&searchWrd=\(keyword ?? "")"
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return getHtmlDoucment(url: encodedStr)
            .flatMap { doc in
                self.getNotice(doc: doc)
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
}



extension CrawlingService {
    private func getHtmlDoucment(url: String) -> AnyPublisher<Document, Error> {
        return Just(url)
            .subscribe(on: DispatchQueue.global())
            .compactMap { URL(string: $0) }
            .tryMap { try String(contentsOf: $0, encoding: .utf8) }
            .tryMap { try SwiftSoup.parse($0) }
            .eraseToAnyPublisher()
    }
    
    private func getNotice(doc: Document) -> AnyPublisher<[Notice], Error> {
        return Just(doc)
            .tryMap { doc -> [Notice] in
                let ids = try doc.select("span.col.col-1.tc").map { try $0.text() }
                let titles = try doc.select("span.col.col-2.dot").select("a").map { try $0.text() }
                let links = try doc.select("span.col.col-2.dot").select("a").map { try $0.attr("href") }
                
                let writers = try doc.select("span.col.col-3.tc")
                    .map { try $0.text() }
                    .map { writer -> String in
                        var tmp = writer
                        let endIndex = tmp.index(tmp.startIndex, offsetBy: 3)
                        tmp.removeSubrange(tmp.startIndex..<endIndex)
                        return tmp
                    }
                let publishDates = try doc.select("span.col.col-5.tc")
                    .map { try $0.text() }
                    .map { date -> String in
                        var tmp = date
                        let endIndex = tmp.index(tmp.startIndex, offsetBy: 3)
                        tmp.removeSubrange(tmp.startIndex..<endIndex)
                        return tmp
                    }
                
                var notices = [Notice]()
                for i in 0..<ids.count {
                    let notice = Notice(
                        id: Int(ids[i])!,
                        title: titles[i],
                        writer: writers[i],
                        publishDate: publishDates[i],
                        detailLink: links[i]
                    )
                    notices.append(notice)
                }

                
                return notices
            }
            .eraseToAnyPublisher()
    }
    
}
