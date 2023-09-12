//
//  NoticeViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/09.
//

import Foundation
import Combine
import UIKit

typealias NoticeDataSource = UICollectionViewDiffableDataSource<Int, Notice>
typealias NoticeSnapshot = NSDiffableDataSourceSnapshot<Int, Notice>

final class NoticeViewModel {
    
    //MARK: - Properties
    let crawlingService: CrawlingServiceType
    
    var cancellables: Set<AnyCancellable> = .init()
    private lazy var todayDateString = Date.todayDateString()
    
    private var noticeDataSource: NoticeDataSource?
    
    //MARK: - Output
    
    // navigation title
    let title: CurrentValueSubject<String?, Never>
    
    // 공지사항 리스트
    private let noticeListSubject: CurrentValueSubject<[Notice], Never> = .init([])
    
    // 로딩 상태
    let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    
    // 블러뷰 isHidden
    let blurViewIsHidden: CurrentValueSubject<Bool, Never> = .init(true)
    
    //MARK: - init
    init(title: String, crawlingService: CrawlingServiceType) {
        //MARK: - 의존성 주입
        self.title = .init(title)
        self.crawlingService = crawlingService
        
        //  공지사항 page publisher 구독
        currentPageSubject.sink { [weak self] page in
            // 다음 페이지 공지사항 요청 및 구독
            self?.getNextPage(page)
        }.store(in: &cancellables)
        
        // 공지사항 publisher 구독
        noticeListSubject
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.updateNotice(with: list) // 섹션 업데이트
            }.store(in: &cancellables)
        
        // 카테고리 탭 publisher 구독
        categorySubject
            .dropFirst()
            .sink { [weak self] category in
                self?.changedCategory(to: category)
            }.store(in: &cancellables)

    }
    
    //MARK: - Input
    
    // 현재 페이지
    private let currentPageSubject: CurrentValueSubject<Int, Never> = .init(1)
    
    // 다음 페이지로 이동
    lazy var nextPage: () -> Void = {
        self.currentPageSubject.send(self.currentPageSubject.value + 1)
    }
    
    // 카테고리 탭
    let categorySubject: CurrentValueSubject<NoticeCategory, Never> = .init(.all)
    
    
    //MARK: - Diffable DataSource
    func setupDataSource(collectionView: UICollectionView) {
        noticeDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, notice in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.noticeCellIdentifier, for: indexPath) as! NoticeCell
            cell.bind(date: self.todayDateString, notice: notice)
            return cell
        })
    }
    
    func updateNotice(with list: [Notice]) {
        var snapshot = NoticeSnapshot() // 스냅샷 생성
        snapshot.appendSections([0])
        snapshot.appendItems(list) // 항목 추가
        noticeDataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
        self.isLoading.send(false)
    }
    
    //MARK: - Helpers
    
    private func getNextPage(_ page: Int) {
        self.isLoading.send(true)
        
        self.crawlingService.noticeCrawl(page: page, keyword: nil, category: self.categorySubject.value)
            .sink(receiveValue: { noticeList in
                var newNotices = self.noticeListSubject.value
                newNotices.append(contentsOf: noticeList)
                newNotices.sort(by: { $0.id > $1.id })
                
                self.noticeListSubject.send(newNotices)
            }).store(in: &cancellables)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(crawlingService: self.crawlingService)
    }
    
    func selectedNoticeItem(index: Int) -> Notice {
        return self.noticeListSubject.value[index]
    }
    
    private func changedCategory(to category: NoticeCategory) {
        self.noticeListSubject.send([])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentPageSubject.send(1)
        }
    }
}
