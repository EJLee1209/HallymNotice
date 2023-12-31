//
//  WeatherApi.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine
import CoreLocation

final class WeatherApi: NetworkServiceType, WeatherApiType {
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let currentWeatherSubject: CurrentValueSubject<WeatherData?, Never> = .init(nil)
    var currentWeather: AnyPublisher<WeatherData?, Never> {
        return currentWeatherSubject.eraseToAnyPublisher()
    }
    
    private let forecastWeatherSubject: CurrentValueSubject<[WeatherData], Never> = .init([])
    var forecastWeather: AnyPublisher<[WeatherData], Never> {
        return forecastWeatherSubject.eraseToAnyPublisher()
    }
    
    private func fetchCurrentWeather(location: CLLocation) -> AnyPublisher<WeatherData?, Never> {
        return composeURL(endPoint: Constants.currentWeatherEndpoint, from: location)
                .flatMap { self.requestGET(url: $0, decodeType: CurrentWeather.self) }
                .map{ WeatherData(currentWeather: $0) }
                .replaceError(with: .none)
                .eraseToAnyPublisher()
    }
    
    private func fetchForecast(location: CLLocation) -> AnyPublisher<[WeatherData], Never> {
        composeURL(endPoint: Constants.forecastEndpoint, from: location)
            .flatMap { self.requestGET(url: $0, decodeType: Forecast.self) }
            .map { $0.list.map(WeatherData.init) }
            .map { forecast in
                var forecast30Hour = [WeatherData]()
                
                if forecast.count > 10 {
                    for i in 0...10 {
                        forecast30Hour.append(forecast[i])
                    }
                }
                return forecast30Hour
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func requestWeather(location: CLLocation) {
        let forecast = self.fetchForecast(location: location)
        let current = self.fetchCurrentWeather(location: location)
        
        current.zip(forecast)
            .sink { [weak self] (current, forecast) in
                self?.currentWeatherSubject.send(current)
                self?.forecastWeatherSubject.send(forecast)
            }.store(in: &cancellables)
    }
    
}
