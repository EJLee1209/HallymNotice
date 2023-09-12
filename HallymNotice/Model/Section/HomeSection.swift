//
//  HomeSection.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/08.
//

import Foundation
import UIKit

enum HomeSection: Hashable, CaseIterable {
    case notice
}

enum HomeSectionItem: Hashable {
    case notice(Notice)
}

typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>
typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>
