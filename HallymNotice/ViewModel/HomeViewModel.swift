//
//  HomeViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine
import UIKit

final class HomeViewModel {
    //MARK: - Properties
    
    // DiffableDataSource
    private var weatherDataSource: ForecastDataSource?
    private var homeDataSource: HomeDataSource?
    
    // Service
    private let locationProvider: LocationProviderType
    private let weatherApi: WeatherApiType
    private let crawlingService: CrawlingServiceType
    private let authService: AuthServiceType
    
    var cancellables: Set<AnyCancellable> = .init()
    private lazy var todayDateString = Date.todayDateString()
    private var user: User?
    
    //MARK: - init
    init(
        locationProvider: LocationProviderType,
        weatherApi: WeatherApiType,
        crawlingService: CrawlingServiceType,
        authService: AuthServiceType
    ) {
        // 의존성 주입
        self.locationProvider = locationProvider
        self.weatherApi = weatherApi
        self.crawlingService = crawlingService
        self.authService = authService
        
        // 현재 날씨 publisher 구독
        self.weatherApi.currentWeather
            .sink { [weak self] data in
                guard let currentWeather = data else { return }
                
                // 현재 온도, 배경 이미지 데이터를 subject로 전달
                self?.currentTempSubject.send("\(Int(currentWeather.temperature))°")
                self?.weatherBackgroundImageName.send(currentWeather.backgroundImageName)
            }.store(in: &cancellables)
        
        // 현재 위치 publisher 구독
        self.locationProvider.currentLocation()
            .sink { [weak self] location in
                self?.weatherApi.requestWeather(location: location) // 위치 기반으로 날씨 데이터 요청
            }.store(in: &cancellables)
        
        // 위치 요청
        self.locationProvider.requestLocation()
        
        // 공지사항 1 페이지 요청, publisher 구독
        self.crawlingService.noticeCrawl(page: 1, keyword: nil, category: .all)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noticeList in
                self?.noticeList.send(noticeList)
                let sectionItem = noticeList.map { HomeSectionItem.notice($0) }
                self?.updateHome(with: sectionItem, toSection: .notice) // notice 섹션 데이터 업데이트
            }.store(in: &cancellables)
    }
    
    //MARK: - Output
    
    // 주소
    var address: AnyPublisher<String, Never> {
        return locationProvider.currentAddress()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // 현재 온도
    private let currentTempSubject: CurrentValueSubject<String, Never> = .init("")
    var currentTemp: AnyPublisher<String, Never> {
        return currentTempSubject
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드로 변경
            .eraseToAnyPublisher()
    }
    
    // 날씨 배경 이미지
    private let weatherBackgroundImageName: CurrentValueSubject<String, Never> = .init("")
    var weatherBackgroundImage: AnyPublisher<UIImage?, Never> {
        return weatherBackgroundImageName
            .map { UIImage(named: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // 날씨 예보
    var forecast: AnyPublisher<[WeatherData], Never> {
        return weatherApi.forecastWeather.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    private let noticeList: CurrentValueSubject<[Notice], Never> = .init([])
    
    private let presentWelcomeVCSubject: PassthroughSubject<Void, Never> = .init()
    var presentWelcomeVC: AnyPublisher<Void, Never> {
        return presentWelcomeVCSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    //MARK: - Intput
    private let showAllNoticeButtonTapSubject: PassthroughSubject<Void, Never> = .init()
    var showAllNoticeButtonTap: AnyPublisher<Void, Never> {
        return showAllNoticeButtonTapSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Home CollectionView DiffableDataSource
    func setupHomeDataSource(collectionView: UICollectionView) {
        homeDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .notice(let notice):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.noticeCellIdentifier, for: indexPath) as! NoticeCell
                cell.bind(date: self.todayDateString, notice: notice)
                return cell
            }
        })
        
        homeDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case Constants.noticeHeaderViewKind:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.noticeHeaderIdentifier, for: indexPath) as! NoticeHeaderView
                header.buttonTapped = { [weak self] in
                    self?.showAllNoticeButtonTapSubject.send(())
                }
                header.bind(viewModel: self)
                return header
            
            default:
                return nil
            }
        }
    }
    
    func updateHome(
        with sectionItem: [HomeSectionItem],
        toSection: HomeSection
    ) {
        var snapshot = HomeSnapshot()
        snapshot.appendSections(HomeSection.allCases)
        snapshot.appendItems(sectionItem, toSection: toSection)
        homeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - HomeHeader CollectionView DiffableDataSource
    func setupWeatherDataSource(collectionView: UICollectionView) {
        weatherDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.forecastCellIdentifier, for: indexPath) as! ForecastCell
            cell.bind(forecast: forecast)
            return cell
        })
    }
    
    func updateWeather(with forecast: [WeatherData]) {
        var snapshot = ForecastSnapshot() // 스냅샷 생성
        snapshot.appendSections(ForecastSection.allCases) // 섹션 추가
        snapshot.appendItems(forecast) // 항목 추가
        weatherDataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
    }
    
    
    //MARK: - Helpers
    func makeNoticeViewModel() -> NoticeViewModel {
        return NoticeViewModel(title: "공지사항", crawlingService: self.crawlingService)
    }
    
    func selectedSectionItem(section: Int, index: Int) -> HomeSectionItem {
        switch HomeSection.allCases[section] {
        case .notice:
            return HomeSectionItem.notice(self.noticeList.value[index])
        }
        
    }
    
    func makeWelcomeViewModel() -> WelcomeViewModel {
        return WelcomeViewModel(authService: self.authService)
    }
    
    func checkUser() {
        let id = UserDefaults.standard.integer(forKey: "myId")
        if id == 0 {
            self.presentWelcomeVCSubject.send(())
            return
        }
        
        self.authService.getUser()
            .sink { completion in
                print("DEBUG checkUser completion: \(completion)")
            } receiveValue: { [weak self] response in
                if response.status == ResponseStatus.error {
                    self?.presentWelcomeVCSubject.send(())
                    return
                }
                
                self?.user = response.user
            }.store(in: &cancellables)
    }
}


