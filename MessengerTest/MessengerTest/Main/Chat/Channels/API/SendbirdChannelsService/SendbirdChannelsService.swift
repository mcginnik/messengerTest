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
        guard let channel = channel.innerObject as? SendbirdChannelProtocol else {
            completion(.failure(ChannelsServiceError.emptyData))
            return
        }
        channel.delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
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
    
    func enterChannel(_ channel: Channel, completion: @escaping (Result<Void, Error>) -> Void ) {
        guard let channel = channel.innerObject as? SendbirdChannelProtocol else {
            completion(.failure(ChannelsServiceError.emptyData))
            return
        }
        channel.enter { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    
    // MARK: API Helpers
    
    private func createOpenChannel(withName name: String,
                                   userID: UserID,
                                   completion: @escaping (Result<Channel, Error>) -> Void) {
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
            
            completion(.success(channel.toChannel()))
        }
    }
    
    private func createGroupChannel(withName name: String,
                                    userID: UserID,
                                    completion: @escaping (Result<Channel, Error>) -> Void) {
        
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
            
            completion(.success(channel.toChannel()))
        }
    }
    
    private func loadNextOpenChannelPage(completion: @escaping (Result<[Channel], Error>) -> Void ) {
        self.openChannelListQuery?.loadNextPage { channels, error in
            guard error == nil else {
                // Handle error.
                completion(.failure(error!))
                return
            }
            
            let channels = channels?.compactMap{$0.toChannel()} ?? []
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
            
            let channels = channels?.compactMap{$0.toChannel()} ?? []
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
                params.includeEmptyChannel = true
                params.myMemberStateFilter = .joinedOnly
                params.order = .latestLastMessage
                params.limit = 15
            }
        }
    }
}




