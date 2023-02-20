//
//  StringConstants.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

struct StringConstants {
    
    static let channel: String = "Channel"
    static let channelsTitle: String = "\(channel)s"
    
    static let addItem: String  = "Add Item"
    static let newChannel: String = "New \(channel)"
    static let channelName: String = "\(channel) Name"
    
    static let createChannelCTA: String = "Create \(channel)"
    static let createChannelDescription: String = "Give your \(channel.lowercased()) a name..."
    static let cancelCTA: String = "Cancel"
    
    static let loading = "Loading..."
}
