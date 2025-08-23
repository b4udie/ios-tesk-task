//
//  AppLifecycleEvent.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

struct AppLifecycleEvent: AnalyticsEventProtocol {
    let action: String
    let date: Date = .now
    
    var name: String { "app_lifecycle" }
    var parameters: [String: String] {
        ["action": action]
    }
}
