//
//  SendbirdMessagesService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import UIKit
import SendbirdChatSDK

class SendbirdMessagesService: MessagesServiceProtocol {
    
    // MARK: Properties
    
    var channelConnections: [String: (Result<BaseMessage, Error>) -> Void] = [:]
    
    // MARK: API
    
    func sendMessage(withText text: String,
                     channel: Channel,
                     completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        let params = UserMessageCreateParams(message: text)
        params.translationTargetLanguages = ["fr", "de"] // French and German
        params.pushNotificationDeliveryOption = .default
        
        if let channel = channel.innerObject as? SendbirdChannelProtocol {
            sendUserMessage(channel: channel, params: params, completion: completion)
        } else {
            completion(.failure(MessagesServiceError.nilChannel))
        }
    }
    
    func sendImageMessage(withImage image: UIImage,
                          channel: Channel,
                          completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        
        if let channel = channel.innerObject as? SendbirdChannelProtocol, let data = image.jpegData(compressionQuality: 0.5) {
            let params = FileMessageCreateParams()
            params.file = data
            Logging.LogMe("... FileMessageCreateParams")
            sendFileMessage(channel: channel, params: [params]) { res in
                switch res {
                case .success:
                    Logging.LogMe("sendFileMessage Success!!!")
                case .failure(let error):
                    Logging.LogMe("... sendFileMessage error \(error)" )
                }
                completion(res)
            }
        } else {
            completion(.failure(MessagesServiceError.nilChannel))
        }
    }
    
    func startMessagesConnection(channel: Channel,
                                 didUpdate: @escaping (Result<ChatMessage, Error>) -> Void) {
        
        
        SendbirdChat.addChannelDelegate(self, identifier: channel.id)
        
        Logging.LogMe("... should have delegate set... \(channel)")
        channelConnections[channel.id] = { res in
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
                                               imageURL: nil)))
            case .failure(let error):
                didUpdate(.failure(error))
            }
        }
        
        
    }
    
    func removeMessagesConnection(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        channelConnections[channel.id] = nil
        SendbirdChat.removeChannelDelegate(forIdentifier: channel.id)
        completion(.success(()))
    }
    
    // MARK: Helpers
    
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
                                            imageURL: nil)))
        }
    }
    
    private func sendFileMessage(channel: SendbirdChannelProtocol,
                                 params: [FileMessageCreateParams],
                                 completion: @escaping (Result<ChatMessage, Error>) -> Void){
        
        _ = channel.sendFileMessages(params: params, progressHandler: nil) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let message = message, let sender = message.sender {
                completion(.success(ChatMessage(id: String(describing: message.id),
                                                type: .file,
                                                createdAt: message.createdAt,
                                                createdBy: User(id: sender.id),
                                                text: "",
                                                imageURL: message.url)))
            } else {
                completion(.failure(MessagesServiceError.emptyData))
            }
        } completionHandler: { _ in }
    }
}

extension SendbirdMessagesService: OpenChannelDelegate {
    
    func channel(_ sender: BaseChannel, didReceive message: BaseMessage) {
        // You can customize how to display the different types of messages
        // with the result object in the message parameter.
        if message is UserMessage {
            channelConnections.forEach { (id, didUpdate) in
                didUpdate(.success(message))
            }
        }
        else if message is FileMessage {
//            Logging.LogMe("...filemessage!")
//            channelConnections.forEach { (id, didUpdate) in
//                didUpdate(.success(message))
//            }
        }
        else if message is AdminMessage {
//            channelConnections.forEach { (id, didUpdate) in
//                didUpdate(.success(message))
//            }
        }
    }
}
