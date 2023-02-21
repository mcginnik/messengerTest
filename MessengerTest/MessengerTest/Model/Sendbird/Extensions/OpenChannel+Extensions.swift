//
//  OpenChannel+Extensions.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import Foundation
import SendbirdChatSDK

// MARK: OpenChannel conformance to SendbirdChannelProtocol
extension OpenChannel: SendbirdChannelProtocol {
    func toChannel() -> Channel {
        Channel(id: self.id,
                url: self.channelURL,
                type: .open,
                createdAt: self.createdAt,
                name: self.name,
                innerObject: self)
    }
}
