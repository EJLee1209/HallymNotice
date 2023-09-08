//
//  ForecastSection.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import UIKit

enum ForecastSection: CaseIterable {
    case forecast
}

typealias ForecastDataSource = UICollectionViewDiffableDataSource<ForecastSection, WeatherData>
typealias ForecastSnapshot = NSDiffableDataSourceSnapshot<ForecastSection, WeatherData>

