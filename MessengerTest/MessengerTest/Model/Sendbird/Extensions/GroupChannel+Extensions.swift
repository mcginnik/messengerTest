//
//  GroupChannel+Extensions.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import Foundation
import SendbirdChatSDK

// MARK: GroupChannel conformance to SendbirdChannelProtocol
extension GroupChannel: SendbirdChannelProtocol {
    
    func toChannel() -> Channel {
        Channel(id: self.id,
                url: self.channelURL,
                type: .group,
                createdAt: self.createdAt,
                name: self.name,
                innerObject: self)
    }
    
    func enter(completionHandler: SBErrorHandler?) {
        join(completionHandler: completionHandler)
    }
    
}
