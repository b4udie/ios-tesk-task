//
//  TransactionEvent.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

struct TransactionEvent: AnalyticsEventProtocol {
    let type: String
    let amount: Double
    let category: String?
    let date: Date = .now
    
    var name: String { "transaction_added" }
    var parameters: [String: String] {
        var params = [
            "type": type,
            "amount": String(format: "%.2f", amount)
        ]
        
        if let category = category {
            params["category"] = category
        }
        
        return params
    }
}
