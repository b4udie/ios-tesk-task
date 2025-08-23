//
//  ErrorEvent.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

struct ErrorEvent: AnalyticsEventProtocol {
    let error: Error
    let context: String
    let date: Date = .now
    
    var name: String { "error_occurred" }
    var parameters: [String: String] {
        [
            "error_description": error.localizedDescription,
            "error_domain": (error as NSError).domain,
            "error_code": String((error as NSError).code),
            "context": context
        ]
    }
}
