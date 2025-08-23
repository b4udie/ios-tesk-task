//
//  BitcoinRateEvent.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

struct BitcoinRateEvent: AnalyticsEventProtocol {
    let rate: Double
    let date: Date = .now
    
    var name: String { "bitcoin_rate_fetched" }
    var parameters: [String: String] {
        [
            "rate": String(format: "%.2f", rate),
            "currency": "USD"
        ]
    }
}
