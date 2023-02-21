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
    let text: String?
    let data: Data?
}

extension ChatMessage: Identifiable, Hashable, Comparable {
    
    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.createdAt > rhs.createdAt
    }
    
}
