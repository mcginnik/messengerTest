//
//  AuthService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

protocol AuthServiceProtocol {
    func login(withEmail email: String, password: String, completion: @escaping (Result<UserID, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}


class AuthService {
    
    // MARK: Properties
    
    static let shared = AuthService()

    /// Allowing for Dependency injection here, calling the injected service instead of directly  so you can easily swap out if need be
    /// Would instead have this be an automatic static injection setup so that all services are set at complie time, but this is a simple way of doing it for now
    ///
    var injected: AuthServiceProtocol?
    
    // MARK: Lifecycle
    
    private init(){}
    
    static func setup(with service: AuthServiceProtocol){
        self.shared.injected = service
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.injected?.login(withEmail: email, password: password) { res in
            DispatchQueue.main.async {
                switch res {
                case .failure(let error):
                    Logging.LogMe("Failed... \(error)")
                case .success(let data):
                    Logging.LogMe("Success...\(data)")
                    break
                }
                completion(res)
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        self.injected?.logout { res in
            DispatchQueue.main.async {
                switch res {
                case .failure(let error):
                    Logging.LogMe("Failed... \(error)")
                case .success:
                    Logging.LogMe("Success...")
                    break
                }
                completion(res)
            }
        }
    }
    
    
}
