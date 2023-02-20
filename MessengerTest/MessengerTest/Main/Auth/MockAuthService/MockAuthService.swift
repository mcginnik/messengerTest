//
//  MockAuthService.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<UserID, Error>) -> Void) {
        completion(.success("307421A8-D395-451F-B192-E62292F16A38"))
        //completion(.success(UUID().uuidString))
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    
}
