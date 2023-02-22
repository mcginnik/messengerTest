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
                await startMessagesConnection()
            }
        }
    }
    
    @Published private(set) var messages: [ChatMessage] = []
    @Published var messageToScrollTo: ChatMessage?
    @Published var shouldAnimateAutoscroll: Bool = true
    @Published var chatInputText: String = ""
    
    private var messageSet: Set<ChatMessage> = [] {
        didSet {
            messages = Array(messageSet).sorted(by: >)
            messageToScrollTo = messages.last
        }
    }
    
    @MainActor
    func sendMessage(withText text: String) async {
        do {
            guard let channel = channel else { throw MessagesServiceError.nilChannel }
            let message = try await AsyncMessagesService.shared.sendMessage(withText: text, channel: channel)
            chatInputText = ""
            insertMessages([message])
            Logging.LogMe("... sending message :) ")
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    @MainActor
    func startMessagesConnection() async {
        do {
            guard let channel = channel else { throw MessagesServiceError.nilChannel }
            try await AsyncChannelsService.shared.enterChannel(channel)
            MessagesService.shared.startMessagesConnection(channel: channel) { [weak self] res in
                switch res {
                case .success(let message):
                    self?.insertMessages([message])
                    Logging.LogMe("Success!... \(message)")
                case .failure(let error):
                    Logging.LogMe("Failed!... \(error)")
                }
            }
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    @MainActor
    func removeMessagesConnection(channel: Channel) async {
        do {
            try await AsyncMessagesService.shared.removeMessagesConnection(channel: channel)
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    func handleSend(){
        Task {
            await sendMessage(withText: chatInputText)
            
        }
    }
    
    // MARK: Helpers
    
    private func insertMessages(_ messages: [ChatMessage]) {
        for message in messages {
            self.messageSet.insert(message)
        }
    }
    
    deinit {
        Logging.LogMe("...")
        guard let channel = channel else { return }
        MessagesService.shared.removeMessagesConnection(channel: channel){_ in }
    }
    
    
}
