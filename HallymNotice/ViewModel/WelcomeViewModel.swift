//
//  WelcomeViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit
import Combine

enum WelcomeSection: CaseIterable {
    case keyword
}

typealias DataSource = UICollectionViewDiffableDataSource<WelcomeSection, String>
typealias Snapshot = NSDiffableDataSourceSnapshot<WelcomeSection, String>

final class WelcomeViewModel {
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var dataSource: DataSource?
    let keywords: CurrentValueSubject<[String],Never>
    
    init(keywords: [String]) {
        self.keywords = .init(keywords)
        
        self.keywords
            .sink { [weak self] update in
                self?.updateHand(with: update)
            }.store(in: &cancellables)
    }
    
    func appendKeyword(_ keyword: String) {
        var newKeywords = keywords.value
        newKeywords.append(keyword)
        keywords.send(newKeywords)
    }
    
    // Diffable Datasource를 구현하기 위해서 2가지 커스텀 메서드를 구현하면 된다.
    // 기존의 UITableViewDataSource/UICollectionViewDataSource 의 필수 메서드 2가지를 커스텀 메서드로 구현하면 됨.
    func setUpDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, keyword in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.keywordCellIdentifier, for: indexPath) as! KeywordCell
            cell.bind(keyword: keyword)
            return cell
        })
    }
    
    func updateHand(with keywords: [String]) {
        var snapshot = Snapshot() // 스냅샷 생성
        snapshot.appendSections(WelcomeSection.allCases) // 섹션 추가
        snapshot.appendItems(keywords) // 항목 추가
        dataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
    }
}
