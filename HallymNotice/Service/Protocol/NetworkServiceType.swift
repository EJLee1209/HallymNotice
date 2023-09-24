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
    
    func requestPost<ResponseType: Decodable, BodyType: Encodable>(
        endPoint: String,
        body: BodyType,
        modelType: ResponseType.Type
    ) -> AnyPublisher<ResponseType, Error> {
        return Just(endPoint)
            .compactMap { URL(string: $0) }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let jsonData = try! JSONEncoder().encode(body)
                request.httpBody = jsonData
                return request
            }
            .flatMap { URLSession.shared.dataTaskPublisher(for: $0) }
            .map(\.data)
            .decode(type: modelType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
