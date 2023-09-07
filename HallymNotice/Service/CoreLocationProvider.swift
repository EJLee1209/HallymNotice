//
//  LocationProviderType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import UIKit
import CoreLocation
import Combine
import CombineCocoa

final class CoreLocationProvider: NSObject, LocationProviderType {
    
    private let locationManager: CLLocationManager = .init()
    
    private let locationSubject: CurrentValueSubject<CLLocation, Never> = .init(CLLocation.hallymUniv)
    
    private let addressSubject: CurrentValueSubject<String, Never> = .init("춘천시")
    
    private let authorized: CurrentValueSubject<Bool, Never> = .init(false)
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationSubject
            .flatMap { [weak self] location -> AnyPublisher<String, Never> in
                self?.reverseGeoCodeLocation(location: location) ?? Just("(알 수 없음)").eraseToAnyPublisher()
            }.sink { [weak self] address in
                self?.addressSubject.send(address)
            }.store(in: &cancellables)
        
    }
    
    func requestLocation() {
        locationManager.requestLocation() // 위치 정보 요청 (한 번만)
    }
    
    func currentLocation() -> AnyPublisher<CLLocation, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    func currentAddress() -> AnyPublisher<String, Never> {
        return addressSubject.eraseToAnyPublisher()
    }
    
    func reverseGeoCodeLocation(location: CLLocation) -> AnyPublisher<String, Never> {
        return Future<String, Never> { promise in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let place = placemarks?.first {
                    if let gu = place.locality, let dong = place.subLocality {
                        promise(.success("\(gu) \(dong)"))
                    } else {
                        promise(.success(place.name ?? "(알 수 없음)"))
                    }
                } else {
                    promise(.success("(알 수 없음)"))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

extension CoreLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationSubject.send(locations.last ?? CLLocation.hallymUniv)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
