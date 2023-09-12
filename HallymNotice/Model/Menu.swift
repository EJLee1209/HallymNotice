//
//  Menu.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/12.
//

import Foundation

enum MenuType: String {
    case studentRestaurant = "학생 식당"
    case staffRestaurant = "교직원 식당"
}

struct Menu: Hashable {
    let type: MenuType
    let imageUrlString: String
    
    var imageUrl: URL? {
        return URL(string: imageUrlString)
    }
}
