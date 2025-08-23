//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation

struct Transaction {
    let id: UUID
    let amount: Double
    let type: TransactionType
    let date: Date
    
    init(amount: Double, type: TransactionType, date: Date = Date()) {
        self.id = UUID()
        self.amount = amount
        self.type = type
        self.date = date
    }
    
    init(id: UUID, amount: Double, type: TransactionType, date: Date) {
        self.id = id
        self.amount = amount
        self.type = type
        self.date = date
    }
}
