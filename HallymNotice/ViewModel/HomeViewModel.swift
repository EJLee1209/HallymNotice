//
//  HomeViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine

final class HomeViewModel {
    
    let locationProvider: LocationProviderType
    let weatherApi: WeatherApiType
    
    var cancellables: Set<AnyCancellable> = .init()
    
    init(locationProvider: LocationProviderType, weatherApi: WeatherApiType) {
        self.locationProvider = locationProvider
        self.weatherApi = weatherApi
        
        locationProvider.requestLocation()
        
        locationProvider.currentLocation()
            .sink { [weak self] location in
                self?.weatherApi.requestWeather(location: location)
            }.store(in: &cancellables)
        
        weatherApi.currentWeather
            .subscribe(on: DispatchQueue.main)
            .sink { data in
                print(data)
            }.store(in: &cancellables)
        
        
    }
    
    var address: AnyPublisher<String, Never> {
        return locationProvider.currentAddress()
    }
    
    
    
}
