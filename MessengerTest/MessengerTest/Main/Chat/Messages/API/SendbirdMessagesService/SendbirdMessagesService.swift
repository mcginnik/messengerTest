//
//  SendbirdMessagesService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import SendbirdChatSDK

class SendbirdMessagesService: MessagesServiceProtocol {

    
    // MARK: Properties
    
    var openChannelConnections: [String: (Result<BaseMessage, Error>) -> Void] = [:]
    var groupChannelConnections: [String: (Result<BaseMessage, Error>) -> Void] = [:]
    
    // MARK: API
    
    func sendMessage(withText text: String,
                     channel: Channel,
                     completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        guard let userID = AuthService.shared.currentUser?.id else {
            completion(.failure(AuthServiceError.emptyUser))
            return
        }
        let params = UserMessageCreateParams(message: text)
        params.translationTargetLanguages = ["fr", "de"] // French and German
        params.pushNotificationDeliveryOption = .default
        
        switch channel.type {
        case .group:
            sendGroupChannelMessage(withParams: params, channel: channel, completion: completion)
        case .open:
            sendOpenChannelMessage(withParams: params, channel: channel, completion: completion)
        }
        
    }
    
    func startMessagesConnection(channel: Channel,
                                 didUpdate: @escaping (Result<ChatMessage, Error>) -> Void) {
        
        
        SendbirdChat.addChannelDelegate(self, identifier: channel.id)
        
        let completionHandler: (Result<BaseMessage, Error>) -> Void = { res in
               switch res {
               case .success(let message):
                   guard message.channelURL == channel.url else {
                       didUpdate(.failure(MessagesServiceError.wrongChannel))
                       return
                   }
                   guard let sender = message.sender else {
                       didUpdate(.failure(MessagesServiceError.emptyData))
                       return
                   }
                   
                   didUpdate(.success(ChatMessage(id: String(describing: message.id),
                                                  type: .text,
                                                  createdAt: message.createdAt,
                                                  createdBy: User(id: sender.id),
                                                  text: message.message,
                                                  data: nil)))
               case .failure(let error):
                   didUpdate(.failure(error))
               }
        }
        
        Logging.LogMe("... should have delegate set... \(channel)")
        switch channel.type {
        case .group:
            groupChannelConnections[channel.id] = completionHandler
        case .open:
            openChannelConnections[channel.id] = completionHandler
        }
    }
    
    func removeMessagesConnection(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        switch channel.type {
        case .open:
            openChannelConnections[channel.id] = nil
        case .group:
            groupChannelConnections[channel.id] = nil
        }
        SendbirdChat.removeChannelDelegate(forIdentifier: channel.id)
        completion(.success(()))
    }
    
    // MARK: Helpers
    
    private func sendOpenChannelMessage(withParams params: UserMessageCreateParams,
                                channel: Channel,
                                completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        SendbirdChannelsService.fetchOpenChannel(withURL: channel.url) { res in
            switch res {
            case .success( let channel):
                    self.sendUserMessage(channel: channel, params: params, completion: completion)
            case .failure(let error):
                Logging.LogMe("couldn't fetch channel")
                completion(.failure(error))
            }
        }
    }
    
    private func sendGroupChannelMessage(withParams params: UserMessageCreateParams,
                                 channel: Channel,
                                 completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        SendbirdChannelsService.fetchGroupChannel(withURL: channel.url) { res in
            switch res {
            case .success( let channel):
                    self.sendUserMessage(channel: channel, params: params, completion: completion)                
            case .failure(let error):
                Logging.LogMe("couldn't fetch channel")
                completion(.failure(error))
            }
        }
    }
    
    private func sendUserMessage(channel: SendbirdChannelProtocol,
                                 params: UserMessageCreateParams,
                                 completion: @escaping (Result<ChatMessage, Error>) -> Void){
        _ = channel.sendUserMessage(params: params) { userMessage, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userMessage = userMessage, let sender = userMessage.sender else {
                completion(.failure(MessagesServiceError.emptyData))
                return
            }
            
            completion(.success(ChatMessage(id: String(describing: userMessage.id),
                                            type: .text,
                                            createdAt: userMessage.createdAt,
                                            createdBy: User(id: sender.id),
                                            text: userMessage.message,
                                            data: nil)))
        }
    }
}

extension SendbirdMessagesService: OpenChannelDelegate {
    
    func channel(_ sender: BaseChannel, didReceive message: BaseMessage) {
        // You can customize how to display the different types of messages
        // with the result object in the message parameter.
        Logging.LogMe("... delegate set? \(message)")
        if message is UserMessage {
            openChannelConnections.forEach { (id, didUpdate) in
                didUpdate(.success(message))
            }
        }
        else if message is FileMessage {

        }
        else if message is AdminMessage {

        }
    }
}
