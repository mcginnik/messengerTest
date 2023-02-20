//
//  MessengerTestApp.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

@main
struct MessengerTestApp: App {
    
    // MARK: Lifecycle
    
    init() {
        injectServices()
        loginAndConnectToChat()
    }
    
    // MARK: Views
    
    var body: some Scene {
        WindowGroup {
            ChannelsView()
        }
    }
    
    // MARK: API
    
    private func loginAndConnectToChat(){
        // Just fake login for now
        login(withEmail: "", password: ""){ res in
            switch res {
            case .success(let userID):
                startChatService(withUserID: userID)
            case .failure(let error):
                Logging.LogMe("Failed! ... \(error)")
            }
        }
    }
    
    private func login(withEmail email: String, password: String, completion: @escaping (Result<UserID, Error>) -> Void) {
        AuthService.shared.login(withEmail: email, password: password, completion: completion)
    }
    
    private func startChatService(withUserID userID: UserID){
        ChatService.shared.initialize(userID: userID) { res in
            switch res {
            case .success:
                Logging.LogMe("Success! ... withUser: \(userID)")
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}

// MARK: Dependency Injection of services
extension MessengerTestApp {
    
    // MARK: Service Setup
    /// These would ideally not be setup this way but injected with a DI service that confirms that each one has a value at compilation time... I already have a setup for this that I built and there are other solutions out there..  For now just injecting them manually here
    private func injectServices(){
        injectAuthService()
        injectChatService()
    }
    
    private func injectAuthService() {
        AuthService.setup(with: MockAuthService())
    }
    
    private func injectChatService(){
        ChatService.setup(with: SendbirdChatService())
    }
    
}
