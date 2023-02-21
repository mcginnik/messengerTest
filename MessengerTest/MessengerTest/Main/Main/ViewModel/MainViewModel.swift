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
        Task {
            await loginAndStartChatService()
        }
    }
    
    // MARK: API
    
    @MainActor
    private func loginAndStartChatService() async {
        // Just fake login for now
            do {
                let userID = try await AsyncAuthService.shared.login(withEmail: "", password: "")
                try await AsyncChatService.shared.initialize(userID: userID)
                self.isAuthenticated = true
            } catch {
                Logging.LogMe("Failed!...")
            }
    }
}
