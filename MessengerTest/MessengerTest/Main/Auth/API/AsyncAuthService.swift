//
//  AsyncAuthService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import Combine

protocol AsyncAuthServiceProtocol {
    func login(withEmail email: String, password: String) async throws -> UserID
    func logout() async throws -> Void
}

class AsyncAuthService: AsyncAuthServiceProtocol {
    
    // MARK: Properties

    static let shared: AsyncAuthServiceProtocol = AsyncAuthService()
    
    // MARK: Lifecycle
    
    private init(){}
    
    // MARK: API
    
    func login(withEmail email: String, password: String) async throws -> UserID {
        
        let future = Future<UserID, Error> { promise in
            AuthService.shared.login(withEmail: email, password: password) { res in
                switch res {
                case .success(let userID):
                    return promise(.success(userID))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        let userID = try await future.async()
        return userID

    }
    
    func logout() async throws {
        let future = Future<Void, Error> { promise in
            AuthService.shared.logout() { res in
                switch res {
                case .success(let userID):
                    return promise(.success(userID))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        try await future.async()

    }
    
}


