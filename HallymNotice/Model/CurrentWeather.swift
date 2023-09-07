//
//  CurrentWeather.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation

struct CurrentWeather: Codable {
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    let weather: [Weather]
    
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    let main: Main
}
