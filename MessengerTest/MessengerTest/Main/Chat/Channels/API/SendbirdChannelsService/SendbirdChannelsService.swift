//
//  SendbirdChannelsService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import SendbirdChatSDK

class SendbirdChannelsService: ChannelsServiceProtocol {
    
    var query: OpenChannelListQuery?
    
    func createChannel(withName name: String, completion: @escaping (Result<Channel, Error>) -> Void) {
        guard let userID = AuthService.shared.currentUser?.id else {
            completion(.failure(AuthServiceError.emptyUser))
            return
        }
        
        let params = OpenChannelCreateParams()
        params.name = name
        params.operatorUserIds = [userID]
        OpenChannel.createChannel(params: params) { channel, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let channel = channel else {
                completion(.failure(ChannelsServiceError.emptyData))
                return
            }
            
            print(channel)
            completion(.success(Channel(id: channel.id, url: channel.channelURL, createdAt: channel.createdAt, name: channel.name)))
            // An open channel is successfully created.
            // Through the channel parameter of the callback method,
            // you can get the open channel's data from the Sendbird server.
        }
    }
    
    func deleteChannel(withURL url: ChannelURL, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchOpenChannel(withURL: url) { res in
            switch res {
            case .success(let openChannel):
                openChannel.delete { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOpenChannel(withURL url: String, completion: @escaping (Result<OpenChannel, Error>) -> Void){
        OpenChannel.getChannel(url: url) { channel, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let channel = channel else {
                completion(.failure(ChannelsServiceError.emptyData))
                return
            }
            completion(.success((channel)))
        }
    }
    
    func fetchOpenChannels(completion: @escaping (Result<[Channel], Error>) -> Void){
        createQuery()
        loadNextPage(completion: completion)
    }

    func loadNextPage(completion: @escaping (Result<[Channel], Error>) -> Void ) {
        self.query?.loadNextPage { channels, error in
            guard error == nil else {
                // Handle error.
                completion(.failure(error!))
                return
            }
            
            let channels = channels?.compactMap{Channel(id: $0.id, url: $0.channelURL, createdAt: $0.createdAt, name: $0.name)} ?? []
            completion(.success(channels))
            // A list of public group channels is retrieved.
        }
    }
    
    private func createQuery() {
        self.query = OpenChannel.createOpenChannelListQuery { params in
            params.limit = 15
        }
    }
    
    
}


