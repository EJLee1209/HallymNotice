//
//  WeatherApiType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherApiType {
    
    func requestWeather(location: CLLocation)
    
    var currentWeather: AnyPublisher<WeatherData?, Never> { get }
    var forecastWeather: AnyPublisher<[WeatherData], Never> { get }
}

extension WeatherApiType {
    
    func composeURL(endPoint: String, from location: CLLocation) -> AnyPublisher<URL, Never> {
        let urlStr = "\(endPoint)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(Constants.weatherApiKey)&lang=kr&units=metric"
        
        print(urlStr)
        return Just(urlStr)
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()
    }
    
}
