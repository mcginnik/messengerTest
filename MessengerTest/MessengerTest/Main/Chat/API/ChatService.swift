//
//  ChatService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

protocol ChatServiceProtocol {
    func initialize(userID: UserID, completion: @escaping (Result<Void, Error>) -> Void)
    func deinitialize()
}

enum ChatServiceError: LocalizedError {
    case emptyUser
    
    var errorDescription: String? {
        switch self {
        case .emptyUser:
            return "Chat User came back empty... can't connect to chat"
        }
    }
}

class ChatService {
    
    // MARK: Properties
    
    static let shared = ChatService()

    /// Allowing for Dependency injection here, calling the injected service instead of directly  so you can easily swap out if need be
    /// Would instead have this be an automatic static injection setup so that all services are set at complie time, but this is a simple way of doing it for now
    /// 
    var injected: ChatServiceProtocol?
    
    // MARK: Lifecycle
    
    private init(){}
    
    static func setup(with service: ChatServiceProtocol){
        self.shared.injected = service
    }
    
    // MARK: API
    
    func initialize(userID: UserID, completion: @escaping (Result<Void, Error>) -> Void) {
        Logging.LogMe("...")
        injected?.initialize(userID: userID) { res in
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
