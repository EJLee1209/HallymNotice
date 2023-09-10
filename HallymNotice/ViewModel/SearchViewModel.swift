//
//  SearchViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/10.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel {
    
    //MARK: - Properties
    
    let crawlingService: CrawlingServiceType
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var noticeDataSource: NoticeDataSource?
    
    private lazy var todayDateString = Date.todayDateString()
    
    //MARK: - init
    init(crawlingService: CrawlingServiceType) {
        self.crawlingService = crawlingService
        
        searchButtonTap
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.searchResultTextIsHidden.send(false)
                self?.guideLabelIsHidden.send(true)
                self?.guideLabelText.send(Constants.searchGuide)
            })
            .map { [weak self] _ in
                self?.searchKeyword.value ?? ""
            }
            .flatMap { [weak self] keyword in
                self?.getSearchList(keyword: keyword) ?? Just([]).eraseToAnyPublisher()
            }
            .sink { [weak self] searchList in
                self?.searchList.send(searchList)
            }.store(in: &cancellables)
        
        cancelButtonTap
            .sink { [weak self] _ in
                self?.searchResultTextIsHidden.send(true)
                self?.guideLabelIsHidden.send(false)
                self?.guideLabelText.send(Constants.searchGuide)
                self?.updateNotice(with: [])
                self?.page.send(1)
            }.store(in: &cancellables)
        
        searchList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                if list.isEmpty { // 검색 결과 없음
                    self?.guideLabelText.send(Constants.searchResultIsEmpty)
                    self?.guideLabelIsHidden.send(false)
                }
                self?.updateNotice(with: list)
            }.store(in: &cancellables)
        
        page.dropFirst()
            .sink { [weak self] page in
                self?.getNextPage(page: page)
            }.store(in: &cancellables)
    }
    
    //MARK: - Intput
    
    // 검색어
    let searchKeyword: CurrentValueSubject<String, Never> = .init("")
    // 검색 버튼 탭
    let searchButtonTap: PassthroughSubject<Void, Never> = .init()
    // 취소 버튼 탭
    let cancelButtonTap: PassthroughSubject<Void, Never> = .init()
    
    // 페이지
    private let page: CurrentValueSubject<Int, Never> = .init(1)
    lazy var nextPage: () -> Void = {
        self.page.send(self.page.value + 1)
    }
    //MARK: - Output
    
    // 검색 결과 리스트
    private let searchList: CurrentValueSubject<[Notice], Never> = .init([])
    
    // 로딩 상태
    let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    
    // 검색 결과 텍스트 isHidden
    let searchResultTextIsHidden: CurrentValueSubject<Bool, Never> = .init(true)
    
    // 검색 안내 text
    let guideLabelText: CurrentValueSubject<String, Never> = .init(Constants.searchGuide)
    
    // 검색 안내 label isHidden
    let guideLabelIsHidden: CurrentValueSubject<Bool, Never> = .init(false)
    
    //MARK: - Diffable DataSource
    func setupDataSource(collectionView: UICollectionView) {
        noticeDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, notice in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.noticeCellIdentifier, for: indexPath) as! NoticeCell
            cell.bind(date: self.todayDateString, notice: notice)
            return cell
        })
    }
    
    private func updateNotice(with list: [Notice]) {
        var snapshot = NoticeSnapshot() // 스냅샷 생성
        snapshot.appendSections([0])
        snapshot.appendItems(list) // 항목 추가
        noticeDataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
        
        isLoading.send(false)
    }
    
    //MARK: - Helpers
    private func getSearchList(keyword: String) -> AnyPublisher<[Notice], Never> {
        page.send(1)
        isLoading.send(true)
        return self.crawlingService.noticeCrawl(page: 1, keyword: keyword)
    }
    
    private func getNextPage(page: Int) {
        if page <= 1 { return }
        
        isLoading.send(true)
        let keyword = searchKeyword.value
        self.crawlingService.noticeCrawl(page: page, keyword: keyword)
            .sink(receiveValue: { noticeList in
                var newNotices = self.searchList.value
                newNotices.append(contentsOf: noticeList)
                newNotices.sort(by: { $0.id > $1.id })
                
                self.searchList.send(newNotices)
            }).store(in: &cancellables)
    }
    
}
