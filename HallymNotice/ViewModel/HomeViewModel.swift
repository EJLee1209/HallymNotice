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
    var cancellables: Set<AnyCancellable> = .init()
    
    init(locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        
        locationProvider.requestLocation()
    }
    
    var address: AnyPublisher<String, Never> {
        return locationProvider.currentAddress()
    }
    
    
    
}
