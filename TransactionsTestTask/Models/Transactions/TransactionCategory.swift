//
//  TransactionCategory.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation

enum TransactionCategory: String, CaseIterable {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    
    var displayName: String {
        switch self {
        case .groceries: 
            "Groceries"
        case .taxi:
            "Taxi"
        case .electronics:
            "Electronics"
        case .restaurant:
            "Restaurant"
        case .other:
            "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .groceries: 
            "🛒"
        case .taxi:
            "🚕"
        case .electronics:
            "📱"
        case .restaurant:
            "🍽️"
        case .other:
            "📦"
        }
    }
}
