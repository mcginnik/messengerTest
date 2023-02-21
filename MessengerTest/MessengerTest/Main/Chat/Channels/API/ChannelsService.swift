//
//  ChannelsService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

protocol ChannelsServiceProtocol {
    func createChannel(withName name: String,
                       type: ChannelType,
                       completion: @escaping (Result<Channel, Error>) -> Void)
    func deleteChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchChannels(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void)
    func loadNextPage(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void )
    func fetchChannel(withURL url: String,
                      type: ChannelType,
                      completion: @escaping (Result<Channel, Error>) -> Void)
    func enterChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void )
}

enum ChannelsServiceError: LocalizedError {
    case emptyData
    case emptyChannelParams

    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Channel data is empty... can't decode..."
        case .emptyChannelParams:
            return "Channel params are empty...  Can't continue..."
        }
    }
}

class ChannelsService {
    
    // MARK: Properties
    
    static let shared = ChannelsService()

    /// Allowing for Dependency injection here, calling the injected service instead of directly  so you can easily swap out if need be
    /// Would instead have this be an automatic static injection setup so that all services are set at complie time, but this is a simple way of doing it for now
    ///
    var injected: ChannelsServiceProtocol?
    
    // MARK: Lifecycle
    
    private init(){}
    
    static func setup(with service: ChannelsServiceProtocol){
        self.shared.injected = service
    }
    
    // MARK: API
    
    func createChannel(withName name: String,
                       type: ChannelType,
                       completion: @escaping (Result<Channel, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.createChannel(withName: name, type: type) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
    func deleteChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.deleteChannel(channel) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
    func fetchChannels(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void ) {
        Logging.LogMe("...")
        injected?.fetchChannels(forType: type) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
    func fetchChannel(withURL url: String,
                      type: ChannelType,
                      completion: @escaping (Result<Channel, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.fetchChannel(withURL: url, type: type) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
    func loadNextPage(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void ) {
        Logging.LogMe("...")
        injected?.loadNextPage(forType: type) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
    func enterChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void ) {
        Logging.LogMe("...")
        injected?.enterChannel(channel) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                completion(res)
            }
        }
    }
    
}
