//
//  MessagesService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

protocol MessagesServiceProtocol {
//    func createChannel(withName name: String, completion: @escaping (Result<Channel, Error>) -> Void)
//    func deleteChannel(withURL url: ChannelURL, completion: @escaping (Result<Void, Error>) -> Void)
//    func fetchOpenChannels(completion: @escaping (Result<[Channel], Error>) -> Void)
//    func loadNextPage(completion: @escaping (Result<[Channel], Error>) -> Void )
    func sendMessage(withText text: String,
                     channel: Channel,
                     completion: @escaping (Result<ChatMessage, Error>) -> Void)
    func startMessagesConnection(channel: Channel,
                                 didUpdate: @escaping (Result<ChatMessage, Error>) -> Void)
    func removeMessagesConnection(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void)
}

enum MessagesServiceError: LocalizedError {
    case emptyData
    case nilChannel
    case wrongChannel

    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Message data is empty..."
        case .nilChannel:
            return "Channel is nil..."
        case .wrongChannel:
            return "Wrong channel for updates"
        }
    }
}

class MessagesService {
    
    // MARK: Properties
    
    static let shared = MessagesService()

    /// Allowing for Dependency injection here, calling the injected service instead of directly  so you can easily swap out if need be
    /// Would instead have this be an automatic static injection setup so that all services are set at complie time, but this is a simple way of doing it for now
    ///
    var injected: MessagesServiceProtocol?
    
    // MARK: Lifecycle
    
    private init(){}
    
    static func setup(with service: MessagesServiceProtocol){
        self.shared.injected = service
    }
    
    // MARK: API
    
    func sendMessage(withText text: String,
                     channel: Channel,
                     completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.sendMessage(withText: text, channel: channel) { res in
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
    
    func startMessagesConnection(channel: Channel,
                                 didUpdate: @escaping (Result<ChatMessage, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.startMessagesConnection(channel: channel) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    Logging.LogMe("Success!...")
                case .failure(let error):
                    Logging.LogMe("Failed! ... \(error)")
                }
                didUpdate(res)
            }
        }
    }
    
    func removeMessagesConnection(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.removeMessagesConnection(channel: channel) { res in
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
    
//    func deleteChannel(withURL url: ChannelURL, completion: @escaping (Result<Void, Error>) -> Void) {
//        Logging.LogMe("...")
//        injected?.deleteChannel(withURL: url) { res in
//            DispatchQueue.main.async {
//                switch res {
//                case .success:
//                    Logging.LogMe("Success!...")
//                case .failure(let error):
//                    Logging.LogMe("Failed! ... \(error)")
//                }
//                completion(res)
//            }
//        }
//    }
//    
//    func fetchOpenChannels(completion: @escaping (Result<[Channel], Error>) -> Void ) {
//        Logging.LogMe("...")
//        injected?.fetchOpenChannels { res in
//            DispatchQueue.main.async {
//                switch res {
//                case .success:
//                    Logging.LogMe("Success!...")
//                case .failure(let error):
//                    Logging.LogMe("Failed! ... \(error)")
//                }
//                completion(res)
//            }
//        }
//    }
//    
//    func loadNextPage(completion: @escaping (Result<[Channel], Error>) -> Void ) {
//        Logging.LogMe("...")
//        injected?.loadNextPage { res in
//            DispatchQueue.main.async {
//                switch res {
//                case .success:
//                    Logging.LogMe("Success!...")
//                case .failure(let error):
//                    Logging.LogMe("Failed! ... \(error)")
//                }
//                completion(res)
//            }
//        }
//    }
    
}
