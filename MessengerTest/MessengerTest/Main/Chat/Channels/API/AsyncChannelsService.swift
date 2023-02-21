//
//  AsyncChannelsService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import Combine

protocol AsyncChannelsServiceProtocol {
    func createChannel(withName name: String,
                       type: ChannelType) async throws -> Channel
    func deleteChannel(_ channel: Channel) async throws -> Void
    func fetchChannels(forType type: ChannelType) async throws -> [Channel]
    func loadNextPage(forType type: ChannelType) async throws -> [Channel]
    func fetchChannel(withURL url: String, type: ChannelType) async throws -> Channel
    func enterChannel(_ channel: Channel) async throws

}

class AsyncChannelsService: AsyncChannelsServiceProtocol {

    // MARK: Properties

    static let shared: AsyncChannelsServiceProtocol = AsyncChannelsService()
    
    // MARK: Lifecycle
    
    private init(){}
    
    // MARK: API
    
    func createChannel(withName name: String,
                       type: ChannelType) async throws -> Channel {
        let future = Future<Channel, Error> { promise in
            ChannelsService.shared.createChannel(withName: name, type: type) { res in
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
    
    func deleteChannel(_ channel: Channel) async throws -> Void {
        let future = Future<Void, Error> { promise in
            ChannelsService.shared.deleteChannel(channel) { res in
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
    
    func fetchChannels(forType type: ChannelType) async throws -> [Channel] {
        let future = Future<[Channel], Error> { promise in
            ChannelsService.shared.fetchChannels(forType: type) { res in
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
    
    func fetchChannel(withURL url: String, type: ChannelType) async throws -> Channel {
        let future = Future<Channel, Error> { promise in
            ChannelsService.shared.fetchChannel(withURL: url, type: type) { res in
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
    
    func enterChannel(_ channel: Channel) async throws -> Void {
        let future = Future<Void, Error> { promise in
            ChannelsService.shared.enterChannel(channel) { res in
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
    
    func loadNextPage(forType type: ChannelType) async throws -> [Channel] {
        let future = Future<[Channel], Error> { promise in
            ChannelsService.shared.loadNextPage(forType: type) { res in
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
