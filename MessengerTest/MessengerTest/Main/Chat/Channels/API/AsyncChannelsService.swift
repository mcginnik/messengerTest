//
//  AsyncChannelsService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import Combine

protocol AsyncChannelsServiceProtocol {
    func createChannel(withName name: String) async throws -> Channel
    func deleteChannel(withURL url: ChannelURL) async throws -> Void
    func fetchOpenChannels() async throws -> [Channel]
    func loadNextPage() async throws -> [Channel]
}

class AsyncChannelsService: AsyncChannelsServiceProtocol {

    // MARK: Properties

    static let shared: AsyncChannelsServiceProtocol = AsyncChannelsService()
    
    // MARK: Lifecycle
    
    private init(){}
    
    // MARK: API
    
    func createChannel(withName name: String) async throws -> Channel {
        let future = Future<Channel, Error> { promise in
            ChannelsService.shared.createChannel(withName: name) { res in
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
    
    func deleteChannel(withURL url: ChannelURL) async throws {
        let future = Future<Void, Error> { promise in
            ChannelsService.shared.deleteChannel(withURL: url) { res in
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
    
    func fetchOpenChannels() async throws -> [Channel] {
        let future = Future<[Channel], Error> { promise in
            ChannelsService.shared.fetchOpenChannels() { res in
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
    
    func loadNextPage() async throws -> [Channel] {
        let future = Future<[Channel], Error> { promise in
            ChannelsService.shared.loadNextPage() { res in
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

    
}
