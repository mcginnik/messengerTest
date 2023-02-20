//
//  Logging.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

/// How important is it to show this Log?
enum LoggingLevel: Int, Comparable {
    case always
    case high
    case medium
    case low
    case never
    
    static func < (lhs: LoggingLevel, rhs: LoggingLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Logging {
    
    static var enabled: Bool = true
    
    static func LogMe(_ message: @autoclosure () -> Any?,
                      loggingLevel: LoggingLevel = .medium,
                      caller: AnyObject? = nil,
                      fileName: String = #file,
                      line: Int = #line,
                      functionName: String = #function){
        guard enabled else { return }
        
        if AppConfig.shared.loggingLevel < loggingLevel {
            return
        }
        
        var callerName: String = ""
        if let caller = caller {
            callerName = String(describing: caller)
        } else {
            let fileNameFormmated = fileName.split(separator: "/").last?.split(separator: ".").first ?? ""
            callerName = String(fileNameFormmated)
        }
        print("::: \(callerName) (L\(line)) -> \(functionName) : \(String(describing: message() ?? ""))")
    }
    
}
