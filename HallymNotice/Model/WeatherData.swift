//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation

struct WeatherData: WeatherDataType, Equatable {
    let id: UUID = .init()
    var code: Int?
    var date: Date?
    var icon: String
    var description: String
    var temperature: Double
    var maxTemperature: Double?
    var minTemperature: Double?
    
    var backgroundImageName: String {
        // 맑음(낮), 맑음(밤), 비, 눈
        let isNight = icon.contains("n") // 밤 or 낮
        
        guard let code else { return isNight ? "bg_clear_night" : "bg_clear" }
        
        switch code {
        case 200...599: // 비
            return isNight ? "bg_rain_night" : "bg_rain"
        case 600...699: // 눈
            return "bg_snow"
        case 700...799, 801...809: // 흐림
            return isNight ? "bg_cloud_night" : "bg_cloud"
        case 800: // 맑음
            return isNight ? "bg_clear_night" : "bg_clear"
            
        default:
            return isNight ? "bg_clear_night" : "bg_clear"
        }
    }
}

extension WeatherData {
    init(currentWeather: CurrentWeather) {
        code = currentWeather.weather.first?.id
        date = Date()
        icon = currentWeather.weather.first?.icon ?? ""
        description = currentWeather.weather.first?.description ?? "알 수 없음"
        temperature = currentWeather.main.temp
        maxTemperature = currentWeather.main.temp_max
        minTemperature = currentWeather.main.temp_min
    }
    
    init(forecastItem: Forecast.ListItem) {
        date = Date(timeIntervalSince1970: TimeInterval(forecastItem.dt))
        icon = forecastItem.weather.first?.icon ?? ""
        description = forecastItem.weather.first?.description ?? "알 수 없음"
        temperature = forecastItem.main.temp
        maxTemperature = nil
        minTemperature = nil
    }
}


extension WeatherData: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.id == rhs.id
    }
}
