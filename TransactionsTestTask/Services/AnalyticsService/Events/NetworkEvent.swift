//
//  NetworkEvent.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

struct NetworkEvent: AnalyticsEventProtocol {
    let endpoint: String
    let method: String
    let statusCode: Int?
    let date: Date = .now
    
    var name: String { "network_request" }
    var parameters: [String: String] {
        var params = [
            "endpoint": endpoint,
            "method": method
        ]
        
        if let statusCode = statusCode {
            params["status_code"] = String(statusCode)
        }
        
        return params
    }
}
