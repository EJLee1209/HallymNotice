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
    
    // DifableSnapshot
    private var homeSnapshot: HomeSnapshot = {
        var snapshot = HomeSnapshot()
        snapshot.appendSections(HomeSection.allCases)
        return snapshot
    }()
    
    // Service
    private let locationProvider: LocationProviderType
    private let weatherApi: WeatherApiType
    
    var cancellables: Set<AnyCancellable> = .init()
    
    
    //MARK: - init
    init(locationProvider: LocationProviderType, weatherApi: WeatherApiType) {
        self.locationProvider = locationProvider
        self.weatherApi = weatherApi
        
        locationProvider.requestLocation()
        
        locationProvider.currentLocation()
            .sink { [weak self] location in
                self?.weatherApi.requestWeather(location: location) // 날씨 요청
            }.store(in: &cancellables)
        
        weatherApi.currentWeather
            .sink { [weak self] data in
                guard let currentWeather = data else { return }
                
                self?.currentTempSubject.send("\(Int(currentWeather.temperature))°")
                self?.weatherBackgroundImageName.send(currentWeather.backgroundImageName)
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
    
    //MARK: - Intput
    
    
    
    //MARK: - Home CollectionView DiffableDataSource
    func setupHomeDataSource(collectionView: UICollectionView) {
        homeDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .menu(let value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuCellIdentifier, for: indexPath) as! MenuCell
                cell.bind(text: value)
                return cell
            case .notice(let value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.noticeCellIdentifier, for: indexPath) as! NoticeCell
                cell.bind(text: value)
                return cell
            }
        })
        
        homeDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.homeHeaderIdentifier, for: indexPath) as! HomeHeaderView
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
        homeSnapshot.appendItems(sectionItem, toSection: toSection)
        homeDataSource?.apply(homeSnapshot, animatingDifferences: true)
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
}
