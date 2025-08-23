//
//  TransactionType.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

enum TransactionType {
    case income
    case expense(TransactionCategory)
    
    var isIncome: Bool {
        switch self {
        case .income:
            true
        case .expense:
            false
        }
    }
    
    var category: TransactionCategory? {
        switch self {
        case .expense(let category):
            category
        case .income:
            nil
        }
    }
}
