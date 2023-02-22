//
//  UserMessage+toChatMessage.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import Foundation
import SendbirdChatSDK

extension UserMessage {
    
    func toChatMessage() -> ChatMessage {
        var creator: User?
        if let sender = self.sender {
            creator = User(id: sender.id)
        }
        
        return ChatMessage(id: String(describing: self.id),
                           type: .text,
                           createdAt: self.createdAt,
                           createdBy: creator,
                           text: self.message,
                           imageURL: nil)
        
    }
}

extension FileMessage {
    
    func toChatMessage() -> ChatMessage {
        var creator: User?
        if let sender = self.sender {
            creator = User(id: sender.id)
        }
        
        return ChatMessage(id: String(describing: self.id),
                           type: .file,
                           createdAt: self.createdAt,
                           createdBy: creator,
                           text: "",
                           imageURL: self.url)
        
    }
}
