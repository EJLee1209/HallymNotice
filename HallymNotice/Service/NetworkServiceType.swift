//
//  NetworkServiceType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/07.
//

import Foundation
import Combine

class NetworkServiceType {
    
    func requestGET<T: Decodable>(url: URL, decodeType: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
