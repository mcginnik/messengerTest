//
//  AppConfig.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

public class AppConfig {

    // MARK: - Properties

    static let shared: AppConfig = AppConfig()
    
    private (set) var loggingLevel: LoggingLevel = .high
    
    private (set) var baseURLString = "www.messengertest.com"
    
    // MARK: - Lifecycle

    private init() {}
    
    // MARK: - API
    
    func setBaseURLString(to url: String){
        self.baseURLString = url
    }

}
