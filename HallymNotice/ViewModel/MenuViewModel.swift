//
//  MenuViewModel.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/23.
//

import Foundation
import Combine

final class MenuViewModel {
    
    private let authService: AuthServiceType
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authService: AuthServiceType) {
        self.authService = authService
        
        user.dropFirst()
            .sink { [weak self] user in
                guard let keywords = user?.keywords else { return }
                self?.keywords.send(keywords)
            }.store(in: &cancellables)
        
        self.getUser()
    }
    
    private var user: CurrentValueSubject<User?, Never> = .init(nil)
    
    private let keywords: CurrentValueSubject<[String], Never> = .init([])
    var keywordsPublisher: AnyPublisher<[String], Never> {
        return keywords.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    var keywordsCount: Int {
        return keywords.value.count
    }
    
    func keyword(for index: Int) -> String {
        return keywords.value[index]
    }
    
    func removeKeyword(for index: Int) {
        var newKeywords = keywords.value
        newKeywords.remove(at: index)
        keywords.send(newKeywords)
        updateKeywords(keywords: newKeywords)
    }
    
    func addKeyword(_ keyword: String) {
        var newKeywords = keywords.value
        
        if !newKeywords.contains(keyword) {
            newKeywords.insert(keyword, at: 0)
            keywords.send(newKeywords)
            updateKeywords(keywords: newKeywords)
        }
    }
    
    private func updateKeywords(keywords: [String]) {
        guard var user = self.user.value else { return }
        user.keywords = keywords
        
        self.authService.updateKeywords(user: user)
            .sink { completion in
                print("DEBUG update : \(completion)")
            } receiveValue: { response in
                print("DEBUG update : \(response)")
            }.store(in: &cancellables)
    }
    
    func getUser() {
        print("DEBUG getUser")
        self.authService.getUser()
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] response in
                self?.user.send(response.user)
            }.store(in: &self.cancellables)
    }
    
    func newUser(user: User?) {
        self.user.send(user)
    }
}
