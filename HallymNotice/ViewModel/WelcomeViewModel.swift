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

typealias KeywordDataSource = UICollectionViewDiffableDataSource<WelcomeSection, Keyword>
typealias KeywordSnapshot = NSDiffableDataSourceSnapshot<WelcomeSection, Keyword>

final class WelcomeViewModel {
    
    private var dataSource: KeywordDataSource?
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let authService: AuthServiceType
    
    //MARK: - Output
    
    // default 키워드들 or 커스텀 키워드
    private let keywordsSubject: CurrentValueSubject<[Keyword],Never>
    var keywords: AnyPublisher<[Keyword],Never> {
        return keywordsSubject.eraseToAnyPublisher()
    }
    
    // 선택된 키워드들
    var selectedKeywords: [String] = []
    
    // 다음 화면으로 넘어갈 수 있는지 유효성 체크(1개 이상 키워드 선택)
    private let validationSubject: CurrentValueSubject<Bool, Never> = .init(false)
    var validation: AnyPublisher<Bool, Never> {
        return validationSubject.eraseToAnyPublisher()
    }
    
//    설정 단계
//    1단계 : 키워드 등록
//    2단계 : 모든 설정 완료
    private let stepSubject: CurrentValueSubject<Int, Never> = .init(1)
    var step: AnyPublisher<Int, Never> {
        return stepSubject.eraseToAnyPublisher()
    }
    
    // GuideView의 Title
    private let guideTitleSubject: CurrentValueSubject<String, Never> = .init(Constants.welcomeTitle1)
    var guideTitle: AnyPublisher<String, Never> {
        return guideTitleSubject.eraseToAnyPublisher()
    }
    
    // GuideView의 SubTitle
    private let guideSubTitleSubject: CurrentValueSubject<String, Never> = .init(Constants.welcomeSubTitle1)
    var guideSubTitle: AnyPublisher<String, Never> {
        return guideSubTitleSubject.eraseToAnyPublisher()
    }
    
    // stepOneView isHidden
    private let stepOneViewIsHiddenSubject: CurrentValueSubject<Bool, Never> = .init(false)
    var stepOneViewIsHidden: AnyPublisher<Bool, Never> {
        return stepOneViewIsHiddenSubject.eraseToAnyPublisher()
    }
    
    // stepThreeView isHidden
    private let stepTwoViewIsHiddenSubject: CurrentValueSubject<Bool, Never> = .init(true)
    var stepTwoViewIsHidden: AnyPublisher<Bool, Never> {
        return stepTwoViewIsHiddenSubject.eraseToAnyPublisher()
    }
    
    private let endOfRegisterSubject: PassthroughSubject<User?, Never> = .init()
    var endOfRegister: AnyPublisher<User?, Never> {
        return endOfRegisterSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    private let errorMsgSubject: PassthroughSubject<String, Never> = .init()
    var errorMsg: AnyPublisher<String, Never> {
        return errorMsgSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    //MARK: - init
    init(authService: AuthServiceType) {
        self.keywordsSubject = .init(Constants.defaultKeywords)
        self.authService = authService
        
        self.keywordsSubject
            .sink { [weak self] update in
                self?.updateHand(with: update)
                
                let selected = update.filter { $0.isSelected }.map { $0.text }
                self?.selectedKeywords = selected
                self?.validationSubject.send(selected.count > 0)
            }.store(in: &cancellables)
    }
    
    private var lastGuideText: String {
        let keywordsCount = selectedKeywords.count
        let subTitle = "\n\(keywordsCount)개 키워드 등록,\n\n공지 사항을 놓치지 않게 해드릴게요."
        
        return subTitle
    }
    
    //MARK: - Input
    
    // 커스텀 키워드 추가
    func appendKeyword(_ keyword: Keyword) {
        var newKeywords = keywordsSubject.value
        if let _ = newKeywords.firstIndex(where: { $0.text == keyword.text }) {
            return // 이미 같은 키워드 존재
        }
        newKeywords.append(keyword)
        keywordsSubject.send(newKeywords)
    }
    // 키워드 선택 action
    func selectKeyword(_ index: Int) {
        var newKeywords = keywordsSubject.value
        newKeywords[index].isSelected.toggle()
        keywordsSubject.send(newKeywords)
    }
    
    
    func stepChanged(step: Int) {
        stepSubject.send(step)
        
        switch step {
        case 1:
            // guideView의 Text 변경
            guideTitleSubject.send(Constants.welcomeTitle1)
            guideSubTitleSubject.send(Constants.welcomeSubTitle1)
            
            // 단계별 View의 isHidden 속성값 변경
            stepOneViewIsHiddenSubject.send(false)
            stepTwoViewIsHiddenSubject.send(true)
        case 2:
            guideTitleSubject.send(Constants.welcomeTitle2)
            guideSubTitleSubject.send(lastGuideText)
            
            stepOneViewIsHiddenSubject.send(true)
            stepTwoViewIsHiddenSubject.send(false)
            
            self.authService.register(keywords: selectedKeywords)
                .sink { [weak self] completion in
                    
                    print("DEBUG register completion: \(completion)")
                } receiveValue: { [weak self] response in
                    guard let id = response.user?.id else { return }
                    
                    UserDefaults.standard.set(id, forKey: "myId")
                    self?.endOfRegisterSubject.send(response.user)
                }.store(in: &cancellables)
        default:
            return
        }
    }
    
    //MARK: - DiffableDataSource
    
    // Diffable Datasource를 구현하기 위해서 2가지 커스텀 메서드를 구현하면 된다.
    // 기존의 UITableViewDataSource/UICollectionViewDataSource 의 필수 메서드 2가지를 커스텀 메서드로 구현하면 됨.
    func setUpDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, keyword in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.keywordCellIdentifier, for: indexPath) as! KeywordCell
            cell.bind(keyword: keyword)
            return cell
        })
    }
    
    func updateHand(with keywords: [Keyword]) {
        var snapshot = KeywordSnapshot() // 스냅샷 생성
        snapshot.appendSections(WelcomeSection.allCases) // 섹션 추가
        snapshot.appendItems(keywords) // 항목 추가
        dataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
    }
    
}
