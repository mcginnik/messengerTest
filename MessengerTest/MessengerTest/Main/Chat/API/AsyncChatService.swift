//
//  AsyncChatService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import Combine

protocol AsyncChatServiceProtocol {
    func initialize(userID: UserID) async throws -> Void
    func deinitialize() async throws -> Void
}

class AsyncChatService: AsyncChatServiceProtocol {

    // MARK: Properties

    static let shared: AsyncChatServiceProtocol = AsyncChatService()
    
    // MARK: Lifecycle
    
    private init(){}
    
    // MARK: API
    
    func initialize(userID: UserID) async throws {
        let future = Future<Void, Error> { promise in
            ChatService.shared.initialize(userID: userID) { res in
                switch res {
                case .success:
                    return promise(.success(()))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        try await future.async()
    }
    
    func deinitialize() async throws {
        let future = Future<Void, Error> { promise in
            ChatService.shared.deinitialize() { res in
                switch res {
                case .success:
                    return promise(.success(()))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        try await future.async()
    }

    
}
