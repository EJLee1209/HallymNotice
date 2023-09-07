//
//  HomeViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine
import UIKit

enum ForecastSection: CaseIterable {
    case forecast
}

typealias ForecastDataSource = UICollectionViewDiffableDataSource<ForecastSection, WeatherData>
typealias ForecastSnapshot = NSDiffableDataSourceSnapshot<ForecastSection, WeatherData>

final class HomeViewModel {
    //MARK: - Properties
    
    private var dataSource: ForecastDataSource?
    
    let locationProvider: LocationProviderType
    let weatherApi: WeatherApiType
    
    var cancellables: Set<AnyCancellable> = .init()
    
    
    //MARK: - init
    init(locationProvider: LocationProviderType, weatherApi: WeatherApiType) {
        self.locationProvider = locationProvider
        self.weatherApi = weatherApi
        
        locationProvider.requestLocation()
        
        locationProvider.currentLocation()
            .sink { [weak self] location in
                self?.weatherApi.requestWeather(location: location)
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
    
    private let weatherBackgroundImageName: CurrentValueSubject<String, Never> = .init("")
    var weatherBackgroundImage: AnyPublisher<UIImage?, Never> {
        return weatherBackgroundImageName
            .map { UIImage(named: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    //MARK: - Intput
    
    
    //MARK: - DiffableDataSource
    
    func setUpDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.forecastCellIdentifier, for: indexPath) as! ForecastCell
            cell.bind(forecast: forecast)
            return cell
        })
    }
    
    func updateHand(with forecast: [WeatherData]) {
        var snapshot = ForecastSnapshot() // 스냅샷 생성
        snapshot.appendSections(ForecastSection.allCases) // 섹션 추가
        snapshot.appendItems(forecast) // 항목 추가
        dataSource?.apply(snapshot, animatingDifferences: true) // 데이터 소스에 적용
    }
}
