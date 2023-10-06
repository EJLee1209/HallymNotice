//
//  AuthServiceType.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/22.
//

import Foundation
import Combine

protocol AuthServiceType {
    func register(keywords: [String]) -> AnyPublisher<AuthResponse, Error>
    func updateUser(user: User) -> AnyPublisher<AuthResponse, Error>
    func getUser() -> AnyPublisher<AuthResponse, Error>
}
