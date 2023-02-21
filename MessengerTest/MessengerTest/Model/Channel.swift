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

struct Channel: Identifiable, Hashable, Comparable {
    
    // Change this to timestamp
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        lhs.createdAt > rhs.createdAt
    }
    
    let id: ChannelID
    let url: ChannelURL
    let type: ChannelType
    let createdAt: Int64
    let name: String
    
    static func getTestChannel() -> Channel {
        .init(id: "", url: "", type: .open, createdAt: 0, name: "Test Channel")
    }
}
