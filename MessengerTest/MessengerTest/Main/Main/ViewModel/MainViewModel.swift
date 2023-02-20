//
//  MainViewModel.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

class MainViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var isAuthenticated: Bool = false {
        didSet {
            print("isAuthenticated \(isAuthenticated)")
        }
    }
    
    init(){
        loginAndStartChatService()
    }
    
    // MARK: API
    
    private func loginAndStartChatService(){
        // Just fake login for now
        login(withEmail: "", password: ""){ [weak self] res in
            switch res {
            case .success(let userID):
                self?.startChatService(withUserID: userID)
            case .failure(let error):
                Logging.LogMe("Failed! ... \(error)")
            }
        }
    }
    
    private func login(withEmail email: String, password: String, completion: @escaping (Result<UserID, Error>) -> Void) {
        AuthService.shared.login(withEmail: email, password: password, completion: completion)
    }
    
    private func startChatService(withUserID userID: UserID){
        ChatService.shared.initialize(userID: userID) { [weak self] res in
            switch res {
            case .success:
                Logging.LogMe("Success! ... withUser: \(userID)")
                self?.isAuthenticated = true
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
