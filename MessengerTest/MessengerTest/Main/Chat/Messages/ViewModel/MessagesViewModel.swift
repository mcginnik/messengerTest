//
//  MessagesViewModel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI
import Combine

class MessagesViewModel: ObservableObject {
    
    var channel: Channel? {
        didSet {
            Task {
                await fetchMessages()
            }
        }
    }
    
    @Published private(set) var messages: [ChatMessage] = []
    
    private var messageSet: Set<ChatMessage> = [] {
        didSet {
            messages = Array(messageSet).sorted()
        }
    }
    
    func sendMessage(withText text: String) async {
//        do {
//            _ = try await AsyncChannelsService.shared.createChannel(withName: name, type: channelType)
//            await self.fetchChannels()
//        } catch {
//            Logging.LogMe("Failed!... \(error)")
//        }
    }
    
    @MainActor
    func fetchMessages() async {
//        do {
//            let channels = try await AsyncChannelsService.shared.fetchChannels(forType: channelType)
//            removeAllChannels()
//            insertChannels(channels)
//        } catch {
//            Logging.LogMe("Failed!... \(error)")
//        }
    }
    
    @MainActor
    func loadPreviousPage() async {
//        do {
//            let channels = try await AsyncChannelsService.shared.loadNextPage(forType: channelType)
//            insertChannels(channels)
//        } catch {
//            Logging.LogMe("Failed!... \(error)")
//        }
    }
    
    // MARK: Helpers
    
    private func insertMessages(_ messages: [ChatMessage]) {
        for message in messages {
            self.messageSet.insert(message)
        }
    }
    
    
}
