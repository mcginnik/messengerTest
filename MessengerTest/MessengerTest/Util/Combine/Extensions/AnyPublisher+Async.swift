//
//  AnyPublisher+Async.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation
import Combine

enum AsyncError: Error {
    case noValueReceived
}

extension AnyPublisher {
    
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var noValueReceived = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if noValueReceived {
                            continuation.resume(throwing: AsyncError.noValueReceived)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    noValueReceived = false
                    continuation.resume(with: .success(value))
                }
        }
    }
    
}
