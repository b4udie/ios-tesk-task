//
//  TransactionGroupViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 24.08.2025.
//

import Foundation

struct TransactionGroupViewModel {
    let date: String
    let transactions: [TransactionViewModel]
    
    init(from group: TransactionGroup) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let today = Date()
        let calendar = Calendar.current
        
        if calendar.isDate(group.date, inSameDayAs: today) {
            date = "Today"
        } else if calendar.isDate(group.date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today) ?? today) {
            date = "Yesterday"
        } else {
            date = formatter.string(from: group.date)
        }

        transactions = group.transactions.map { TransactionViewModel(from: $0) }
    }
}
