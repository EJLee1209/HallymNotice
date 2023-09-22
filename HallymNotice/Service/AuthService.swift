//
//  AuthService.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/22.
//

import Foundation
import Combine

enum ApiError: Error {
    case emptyToken
}

struct AuthResponse: Codable {
    let success: Bool
}

final class AuthService: NetworkServiceType {
    
    func saveUser(keywords: [String]) -> AnyPublisher<AuthResponse, Error> {
        guard let token = getFCMToken() else { return Empty().eraseToAnyPublisher() }
        
        let endpoint = "\(Constants.BASE_URL)/user"
        let user = User(fcmToken: token, keywords: keywords)
        return requestPost(endPoint: endpoint, body: user, modelType: AuthResponse.self)
    }
    
    func updateUser(keywords: [String]) -> AnyPublisher<AuthResponse, Error> {
        guard let token = getFCMToken() else { return Empty().eraseToAnyPublisher() }
        
        let endpoint = "\(Constants.BASE_URL)/update"
        let user = User(fcmToken: token, keywords: keywords)
        return requestPost(endPoint: endpoint, body: user, modelType: AuthResponse.self)
    }
    
    func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: "fcmToken")
    }
    
}
