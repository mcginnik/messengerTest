//
//  Channel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

typealias ChannelID = String
typealias ChannelURL = String

enum ChannelType: CaseIterable {
    case open
    case group
    
    var descriptionCTA: String {
        switch self {
        case .open:
            return StringConstants.openChannelsCTA
        case .group:
            return StringConstants.groupChannelsCTA
        }
    }
}

struct Channel {
    
    // Change this to timestamp
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        lhs.createdAt > rhs.createdAt
    }
    
    let id: ChannelID
    let url: ChannelURL
    let type: ChannelType
    let createdAt: Int64
    let name: String
    let innerObject: Any?
    
    static func getTestChannel() -> Channel {
        .init(id: "", url: "", type: .open, createdAt: 0, name: "Test Channel", innerObject: nil)
    }
}

extension Channel: Identifiable, Hashable, Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
