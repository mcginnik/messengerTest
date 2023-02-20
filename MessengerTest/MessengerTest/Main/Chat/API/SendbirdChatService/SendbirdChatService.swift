//
//  SendbirdChatService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import SendbirdChatSDK

class SendbirdChatService: ChatServiceProtocol {
    
    static let defaultConfig = SendbirdChatConfig()
    
    let config = SendbirdChatService.defaultConfig
    
    func initialize(userID: UserID, completion: @escaping (Result<Void, Error>) -> Void) {
        let initParams = InitParams(
            applicationId: config.appID,
            isLocalCachingEnabled: true,
            logLevel: .info
        )

        SendbirdChat.initialize(params: initParams,
                                migrationStartHandler: {
            //
        }, completionHandler: { [weak self] error in
            guard error == nil else {
                Logging.LogMe("... FAILED! \(String(describing: error))")
                return
            }
            
            self?.connectToServer(withUserID: userID, completion: completion)
            
            Logging.LogMe("Success!")
        })
    }
    
    func connectToServer(withUserID userID: UserID, completion: @escaping (Result<Void, Error>) -> Void) {
        SendbirdChat.connect(userId: userID) { user, error in
            guard let user = user, error == nil else {
                // Handle error.
                if let error = error {
                    completion(.failure(error))
                }
                if user == nil {
                    completion(.failure(ChatServiceError.emptyUser))
                }
                return
            }

            // The user is connected to the Sendbird server.
            Logging.LogMe("... Success! \(user)")
            completion(.success(()))
        }
    }
    
    func deinitialize() {
        //
    }
    
    
    
}
