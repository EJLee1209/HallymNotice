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

enum ResponseStatus: String, Codable {
    case error
    case success
}

struct AuthResponse: Codable {
    let status: ResponseStatus
    let errorMsg: String?
    let user: User?
}

final class AuthService: NetworkServiceType, AuthServiceType {
    func register(keywords: [String]) -> AnyPublisher<AuthResponse, Error> {
        guard let token = getFCMToken() else { return Empty().eraseToAnyPublisher() }
        
        let endpoint = "\(Constants.BASE_URL)/register"
        let user = User(id: 0, fcmToken: token, keywords: keywords)
        return requestPost(endPoint: endpoint, body: user, modelType: AuthResponse.self)
    }
    
    func updateKeywords(user: User) -> AnyPublisher<AuthResponse, Error> {
        guard let token = getFCMToken() else { return Empty().eraseToAnyPublisher() }
        
        let endpoint = "\(Constants.BASE_URL)/update/keywords"
        print("DEBUG update keywords user : \(user)")
        return requestPost(endPoint: endpoint, body: user, modelType: AuthResponse.self)
    }
    
    func getUser() -> AnyPublisher<AuthResponse, Error> {
        let endPoint = "\(Constants.BASE_URL)/user?id=\(getId())"
        let url = URL(string: endPoint)!
        return requestGET(url: url, decodeType: AuthResponse.self)
    }
    
    private func getId() -> Int {
        return UserDefaults.standard.integer(forKey: "myId")
    }
    
    private func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: "fcmToken")
    }
}
