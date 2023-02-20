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
    }
    
    // MARK: Views
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
        injectChannelsService()
    }
    
    private func injectAuthService() {
        AuthService.setup(with: MockAuthService())
    }
    
    private func injectChatService(){
        ChatService.setup(with: SendbirdChatService())
    }
    
    private func injectChannelsService() {
        ChannelsService.setup(with: SendbirdChannelsService())
    }
    
}
