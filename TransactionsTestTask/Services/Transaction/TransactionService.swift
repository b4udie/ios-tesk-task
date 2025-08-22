//
//  TransactionService.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation
import Combine

protocol TransactionService: AnyObject {
    var transactionsPublisher: AnyPublisher<[TransactionGroup], Never> { get }
    var balancePublisher: AnyPublisher<Double, Never> { get }
    
    func addTransaction(_ transaction: Transaction)
    func addIncome(_ amount: Double)
    func loadTransactions(page: Int, pageSize: Int)
}

final class TransactionServiceImpl: TransactionService {
    private let transactionsSubject = CurrentValueSubject<[Transaction], Never>([])
    private let balanceSubject = CurrentValueSubject<Double, Never>(0.0)
    
    var transactionsPublisher: AnyPublisher<[TransactionGroup], Never> {
        transactionsSubject
            .map { transactions in
                let grouped = Dictionary(grouping: transactions) { transaction in
                    Calendar.current.startOfDay(for: transaction.date)
                }
                return grouped.map { (date, transactions) in
                    TransactionGroup(date: date, transactions: transactions.sorted { $0.date > $1.date })
                }.sorted { $0.date > $1.date }
            }
            .eraseToAnyPublisher()
    }
    
    var balancePublisher: AnyPublisher<Double, Never> {
        balanceSubject.eraseToAnyPublisher()
    }
    
    init() {
        let testTransactions = [
            Transaction(amount: 0.5, type: .expense(.groceries), date: Date().addingTimeInterval(-3600)),
            Transaction(amount: 0.2, type: .expense(.taxi), date: Date().addingTimeInterval(-7200)),
            Transaction(amount: 1.0, type: .income, date: Date().addingTimeInterval(-86400)),
            Transaction(amount: 0.3, type: .expense(.restaurant), date: Date().addingTimeInterval(-172800)),
        ]
        
        transactionsSubject.send(testTransactions)
        updateBalance()
    }
    
    func addTransaction(_ transaction: Transaction) {
        var currentTransactions = transactionsSubject.value
        currentTransactions.append(transaction)
        transactionsSubject.send(currentTransactions)
        updateBalance()
    }
    
    func addIncome(_ amount: Double) {
        let incomeTransaction = Transaction(amount: amount, type: .income)
        addTransaction(incomeTransaction)
    }
    
    func loadTransactions(page: Int, pageSize: Int) {
        
    }
    
    private func updateBalance() {
        let balance = transactionsSubject.value.reduce(0.0) { result, transaction in
            switch transaction.type {
            case .income:
                return result + transaction.amount
            case .expense:
                return result - transaction.amount
            }
        }
        balanceSubject.send(balance)
    }
}
