//
//  AsyncMessagesService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import UIKit
import Combine

protocol AsyncMessagesServiceProtocol {
    func sendMessage(withText text: String, channel: Channel) async throws -> ChatMessage
    func sendImageMessage(withImage image: UIImage, channel: Channel) async throws -> ChatMessage
    func startMessagesConnection(channel: Channel) async throws -> ChatMessage
    func removeMessagesConnection(channel: Channel) async throws
}

class AsyncMessagesService: AsyncMessagesServiceProtocol {

    // MARK: Properties

    static let shared: AsyncMessagesServiceProtocol = AsyncMessagesService()
    
    // MARK: Lifecycle
    
    private init(){}
    
    // MARK: API
    
    func sendMessage(withText text: String, channel: Channel) async throws -> ChatMessage {
        let future = Future<ChatMessage, Error> { promise in
            MessagesService.shared.sendMessage(withText: text, channel: channel) { res in
                switch res {
                case .success(let data):
                    return promise(.success(data))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        let res = try await future.async()
        return res
    }
    
    func sendImageMessage(withImage image: UIImage, channel: Channel) async throws -> ChatMessage {
        let future = Future<ChatMessage, Error> { promise in
            MessagesService.shared.sendImageMessage(withImage: image, channel: channel) { res in
                switch res {
                case .success(let data):
                    return promise(.success(data))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        let res = try await future.async()
        return res
        
    }

    
    func startMessagesConnection(channel: Channel) async throws -> ChatMessage {
        let future = Future<ChatMessage, Error> { promise in
            MessagesService.shared.startMessagesConnection(channel: channel) { res in
                switch res {
                case .success(let data):
                    return promise(.success(data))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        let res = try await future.async()
        return res
    }
    
    func removeMessagesConnection(channel: Channel) async throws {
        let future = Future<Void, Error> { promise in
            MessagesService.shared.removeMessagesConnection(channel: channel) { res in
                switch res {
                case .success(let data):
                    return promise(.success(data))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
        try await future.async()
    }
    
    
}
