//
//  Channel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

typealias ChannelID = String
typealias ChannelURL = String

struct Channel: Identifiable, Hashable, Comparable {
    
    // Change this to timestamp
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        lhs.createdAt > rhs.createdAt
    }
    
    let id: ChannelID
    let url: ChannelURL
    let createdAt: Int64
    let name: String
    
}
