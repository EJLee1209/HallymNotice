//
//  LocationProviderType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine
import CoreLocation

protocol LocationProviderType {
    
    // 현재 위치를 방출하는 옵저버블을 리턴
    @discardableResult
    func currentLocation() -> AnyPublisher<CLLocation, Never>
    
    // 위도, 경도를 통해 현재 주소를 문자열 형태로 방출하는 옵저버블을 리턴
    @discardableResult
    func currentAddress() -> AnyPublisher<String, Never>
    
    @discardableResult
    func reverseGeoCodeLocation(location: CLLocation) -> AnyPublisher<String, Never>
    
    func requestLocation()
    
}
