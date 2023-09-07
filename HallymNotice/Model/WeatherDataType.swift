//
//  WeatherDataType.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation

protocol WeatherDataType {
    var code: Int? { get }
    var date: Date? { get }
    var icon: String { get }
    var description: String { get }
    var temperature: Double { get }
    var maxTemperature: Double? { get }
    var minTemperature: Double? { get }
    
    var backgroundImageName: String { get }
}
