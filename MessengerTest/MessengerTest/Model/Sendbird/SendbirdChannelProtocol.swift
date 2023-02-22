//
//  SendbirdChannelProtocol.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import Foundation
import SendbirdChatSDK

// MARK: SendbirdChannelProtocol to allow simplification of redundant calls for multiple channel types
protocol SendbirdChannelProtocol {
    
    func enter(completionHandler: SBErrorHandler?)
    
    func sendUserMessage(params: UserMessageCreateParams,
                         completionHandler: SendbirdChatSDK.UserMessageHandler?) -> SendbirdChatSDK.UserMessage
    
    func sendFileMessages(params: [FileMessageCreateParams],
                          progressHandler: MultiProgressHandler?,
                          sentMessageHandler: FileMessageHandler?,
                          completionHandler: SBErrorHandler?) -> [FileMessage]
    
    func toChannel() -> Channel
    
    func delete(completionHandler: SBErrorHandler?)
}



