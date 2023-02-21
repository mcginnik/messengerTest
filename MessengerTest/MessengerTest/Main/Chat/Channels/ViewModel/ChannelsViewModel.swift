//
//  ChannelsViewModel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI
import Combine

class ChannelsViewModel: ObservableObject {
    
    @Published private(set) var channels: [Channel] = []
    
    private var channelSet: Set<Channel> = [] {
        didSet {
            channels = Array(channelSet).sorted()
        }
    }
    
    init() {
        Task {
            await fetchOpenChannels()
        }
    }
    
    func createChannel(withName name: String) async {
        do {
            _ = try await AsyncChannelsService.shared.createChannel(withName: name)
            await self.fetchOpenChannels()
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    @MainActor
    func fetchOpenChannels() async {
        do {
            let channels = try await AsyncChannelsService.shared.fetchOpenChannels()
            removeAllChannels()
            insertChannels(channels)
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    @MainActor
    func loadNextPage() async {
        do {
            let channels = try await AsyncChannelsService.shared.loadNextPage()
            insertChannels(channels)
        } catch {
            Logging.LogMe("Failed!... \(error)")
        }
    }
    
    @MainActor
    func deleteChannels(at indices: IndexSet) async {
        for index in indices {
            let channel = channels[index]
            do {
                await deleteChannel(channel)
                self.channelSet.remove(channel)
            }
        }
    }
    
    private func deleteChannel(_ channel: Channel) async {
        do {
            try await AsyncChannelsService.shared.deleteChannel(withURL: channel.url)
        } catch {
            Logging.LogMe("Failed!  Deleting channel: \(channel.id), error \(error)")
        }
    }
    
    // MARK: Helpers
    
    private func removeAllChannels(){
        self.channelSet.removeAll()
    }
    
    private func insertChannels(_ channels: [Channel]) {
        for channel in channels {
            self.channelSet.insert(channel)
        }
    }
    
    
}
