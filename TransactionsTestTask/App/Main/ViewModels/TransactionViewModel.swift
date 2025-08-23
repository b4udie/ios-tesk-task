//
//  TransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

struct TransactionViewModel {
    let formattedAmount: String
    let amountColor: UIColor
    let categoryIcon: String
    let categoryName: String
    let formattedTime: String
    
    init(from transaction: Transaction) {
        switch transaction.type {
        case .income:
            formattedAmount = String(format: "+%.4f BTC", transaction.amount)
            amountColor = .successGreen
        case .expense:
            formattedAmount = String(format: "-%.4f BTC", transaction.amount)
            amountColor = .errorRed
        }
        
        switch transaction.type {
        case .income:
            self.categoryIcon = "💰"
            self.categoryName = "Income"
        case .expense(let category):
            self.categoryIcon = category.icon
            self.categoryName = category.displayName
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        self.formattedTime = timeFormatter.string(from: transaction.date)
    }
}
