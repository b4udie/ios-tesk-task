//
//  CDTransaction+Domain.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

extension CDTransaction {
    func update(from transaction: Transaction) {
        id = transaction.id
        amount = transaction.amount
        date = transaction.date
        switch transaction.type {
        case .income:
            isIncome = true
            category = nil
        case .expense(let category):
            isIncome = false
            self.category = category.rawValue
        }
    }

    func toDomain() -> Transaction {
        let type: TransactionType = isIncome
            ? .income
            : .expense(TransactionCategory(rawValue: category ?? "") ?? .other)
        return Transaction(id: id ?? UUID(), amount: amount, type: type, date: date ?? Date())
    }
}
