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
    
    private var cancellables = Set<AnyCancellable>()
    private let noticeSubject: CurrentValueSubject<[Notice], Never> = .init([])
    var noticePublisher: AnyPublisher<[Notice], Never> {
        return noticeSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func noticeCrawl(page: Int) {
        
        let urlString = "https://www.hallym.ac.kr/hallym_univ/sub05/cP3/sCP1?nttId=0&bbsTyCode=BBST00&bbsAttrbCode=BBSA03&authFlag=N&pageIndex=\(page)&searchType=0&searchWrd="
        return getHtmlDoucment(url: urlString)
            .flatMap { doc in
                self.getNotice(doc: doc)
            }
            .replaceError(with: [])
            .sink { completion in
                print(completion)
            } receiveValue: { notices in
                var newNotices = self.noticeSubject.value
                newNotices.append(contentsOf: notices)
                newNotices.sort(by: { $0.id > $1.id })
                
                self.noticeSubject.send(newNotices)
            }.store(in: &cancellables)
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
                var titles = try doc.select("span.col.col-2.dot").select("a").map { try $0.text() }
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
