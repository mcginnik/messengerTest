//
//  ChannelsViewModel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI
import Combine

class ChannelsViewModel: ObservableObject {
    
    @Published var channels: [Channel] = []
    
    var channelSet: Set<Channel> = [] {
        didSet {
            channels = Array(channelSet).sorted()
        }
    }
    
    func createChannel(withName name: String) {
        ChannelsService.shared.createChannel(withName: name) { [weak self] res in
            switch res {
            case .success(_):
                Logging.LogMe("Successfully created channel")
                self?.fetchOpenChannels()
            case .failure(let error):
                Logging.LogMe("Failed!... \(error)")
            }
        }
    }
    
    func fetchOpenChannels(){
        ChannelsService.shared.fetchOpenChannels { [weak self] res in
            switch res {
            case .success(let channels):
                for channel in channels {
                    self?.channelSet.insert(channel)
                }
                Logging.LogMe("Success!.. adding channels \(channels)")
            case .failure(let error):
                Logging.LogMe("Failed!... \(error)")
            }
        }
    }
    
    func loadNextPage(){
        ChannelsService.shared.loadNextPage { [weak self] res in
            switch res {
            case .success(let channels):
                for channel in channels {
                    self?.channelSet.insert(channel)
                }
                Logging.LogMe("Success!.. adding channels \(channels)")
            case .failure(let error):
                Logging.LogMe("Failed!... \(error)")
            }
        }
    }
    
    func deleteChannels(at indices: IndexSet){
        for index in indices {
            let channel = channels[index]
            deleteChannel(channel) { [weak self] res in
                switch res {
                case .success:
                    self?.channelSet.remove(channel)
                case .failure:
                    Logging.LogMe("Failed... couldn't delete channels!")
                }
            }
        }
    }
    
    private func deleteChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        ChannelsService.shared.deleteChannel(withURL: channel.url) { res in
            switch res {
            case .success:
                Logging.LogMe("Success!  Deleted channel: \(channel.id)")
            case .failure(let error):
                Logging.LogMe("Failed!  Deleting channel: \(channel.id), error \(error)")
            }
            completion(res)
        }
    }
    
    
}
