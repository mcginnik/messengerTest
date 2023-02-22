//
//  ChatMessage.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

typealias ChatMessageID = String

enum ChatMessageType {
    case text
    case file
}

struct ChatMessage {
    
    let id: ChatMessageID
    let type: ChatMessageType
    let createdAt: Int64
    let createdBy: User
    let text: String?
    let imageURL: String?
    
    static func getTestMessage() -> ChatMessage {
        return .init(id: "",
                     type: .text,
                     createdAt: 0,
                     createdBy: .init(id: "0"),
                     text: "test message",
                     imageURL: nil)
    }
}

extension ChatMessage: Identifiable, Hashable, Comparable {
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.createdAt > rhs.createdAt
    }
    
}
