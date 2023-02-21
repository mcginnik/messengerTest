//
//  SendbirdChannelsService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import SendbirdChatSDK

class SendbirdChannelsService: ChannelsServiceProtocol {
    
    // MARK: Properties
    
    var openChannelListQuery: OpenChannelListQuery?
    var groupChannelListQuery: GroupChannelListQuery?
    
    // MARK: API
    
    func createChannel(withName name: String,
                       type: ChannelType,
                       completion: @escaping (Result<Channel, Error>) -> Void) {
        guard let userID = AuthService.shared.currentUser?.id else {
            completion(.failure(AuthServiceError.emptyUser))
            return
        }
        switch type {
        case .open:
            createOpenChannel(withName: name, userID: userID, completion: completion)
        case .group:
            createGroupChannel(withName: name, userID: userID, completion: completion)
        }
    }
    
    func deleteChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        switch channel.type {
        case .open:
            deleteOpenChannel(withURL: channel.url, completion: completion)
        case .group:
            deleteGroupChannel(withURL: channel.url, completion: completion)
        }
    }
    
    func fetchChannels(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void){
        createQuery(forType: type)
        loadNextPage(forType: type, completion: completion)
    }
    
    func loadNextPage(forType type: ChannelType, completion: @escaping (Result<[Channel], Error>) -> Void ) {
        switch type {
        case .open:
            loadNextOpenChannelPage(completion: completion)
        case .group:
            loadNextGroupChannelPage(completion: completion)
        }
    }
    
    // MARK: API Helpers
    
    private func createOpenChannel(withName name: String,
                                   userID: UserID,
                                   completion: @escaping (Result<Channel, Error>) -> Void) {
        let channelType: ChannelType = .open
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
            
            completion(.success(
                Channel(id: channel.id,
                        url: channel.channelURL,
                        type: channelType,
                        createdAt: channel.createdAt,
                        name: channel.name)
            ))
        }
    }
    
    private func createGroupChannel(withName name: String,
                                    userID: UserID,
                                    completion: @escaping (Result<Channel, Error>) -> Void) {
        
        let channelType: ChannelType = .group
        let params = GroupChannelCreateParams()
        params.name = name
        params.operatorUserIds = [userID]
        GroupChannel.createChannel(params: params) { channel, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let channel = channel else {
                completion(.failure(ChannelsServiceError.emptyData))
                return
            }
            
            completion(.success(
                Channel(id: channel.id,
                        url: channel.channelURL,
                        type: channelType,
                        createdAt: channel.createdAt,
                        name: channel.name)
            ))
        }
    }
    
    private func deleteOpenChannel(withURL url: ChannelURL, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchOpenChannel(withURL: url) { res in
            switch res {
            case .success(let channel):
                channel.delete { error in
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
    
    private func deleteGroupChannel(withURL url: ChannelURL, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchGroupChannel(withURL: url) { res in
            switch res {
            case .success(let channel):
                channel.delete { error in
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
    
    private func fetchOpenChannel(withURL url: String, completion: @escaping (Result<OpenChannel, Error>) -> Void){
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
    
    private func fetchGroupChannel(withURL url: String, completion: @escaping (Result<GroupChannel, Error>) -> Void){
        GroupChannel.getChannel(url: url) { channel, error in
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
    
    private func loadNextOpenChannelPage(completion: @escaping (Result<[Channel], Error>) -> Void ) {
        self.openChannelListQuery?.loadNextPage { channels, error in
            guard error == nil else {
                // Handle error.
                completion(.failure(error!))
                return
            }
            
            let channels = channels?.compactMap{Channel(id: $0.id,
                                                        url: $0.channelURL,
                                                        type: .open,
                                                        createdAt: $0.createdAt,
                                                        name: $0.name)} ?? []
            completion(.success(channels))
            // A list of public group channels is retrieved.
        }
    }
    
    private func loadNextGroupChannelPage(completion: @escaping (Result<[Channel], Error>) -> Void ) {
        self.groupChannelListQuery?.loadNextPage { channels, error in
            guard error == nil else {
                // Handle error.
                completion(.failure(error!))
                return
            }
            
            let channels = channels?.compactMap{Channel(id: $0.id,
                                                        url: $0.channelURL,
                                                        type: .group,
                                                        createdAt: $0.createdAt,
                                                        name: $0.name)} ?? []
            completion(.success(channels))
            // A list of public group channels is retrieved.
        }
    }
    
    private func createQuery(forType type: ChannelType) {
        switch type {
        case .open:
            self.openChannelListQuery = OpenChannel.createOpenChannelListQuery { params in
                params.limit = 15
            }
        case .group:
            self.groupChannelListQuery = GroupChannel.createMyGroupChannelListQuery { params in
                // The `params` object is the `GroupChannelListQueryParams` class.
                params.includeEmptyChannel = true
                params.myMemberStateFilter = .joinedOnly   // Acceptable values are .all, .joinedOnly, .invitedOnly, .invitedByFriend, and .invitedByNonFriend.
                params.order = .latestLastMessage    // Acceptable values are .chronological, .latestLastMessage, .channelNameAlphabetical, and .channelMetaDataValueAlphabetical.
                params.limit = 15
            }
        }

    }
    
    
}
