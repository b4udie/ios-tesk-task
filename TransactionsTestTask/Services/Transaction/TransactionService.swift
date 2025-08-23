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
    var hasMorePages: Bool { get }

    func addTransaction(_ transaction: Transaction)
    func addIncome(_ amount: Double)
    func loadNextPage()
}

final class TransactionServiceImpl: TransactionService {
    private let balanceSubject = CurrentValueSubject<Double, Never>(0.0)
    private let transactionGroupsSubject = CurrentValueSubject<[TransactionGroup], Never>([])

    private var cancellables = Set<AnyCancellable>()
    private let store: TransactionStore
    private let analyticsService: AnalyticsService
    
    private let pageSize = 20
    private var currentPage = 0
    private var allTransactions: [Transaction] = []
    private var isLoading = false

    init(transactionStore: TransactionStore, analyticsService: AnalyticsService) {
        self.store = transactionStore
        self.analyticsService = analyticsService
        loadInitialTransactions()
        loadCurrentBalance()
    }

    var transactionsPublisher: AnyPublisher<[TransactionGroup], Never> {
        transactionGroupsSubject.eraseToAnyPublisher()
    }

    var balancePublisher: AnyPublisher<Double, Never> {
        balanceSubject.eraseToAnyPublisher()
    }
    var hasMorePages: Bool {
        let totalCount = (try? store.fetchTotalCount()) ?? 0
        return (currentPage + 1) * pageSize < totalCount + pageSize
    }

    func addTransaction(_ transaction: Transaction) {
        Task {
            do {
                try await store.insert(transaction)
                await updateBalanceAfterTransaction(transaction)
                await reloadTransactionsForCurrentPage()
                
                let transactionEvent = TransactionEvent(
                    type: transaction.type.isIncome ? "income" : "expense",
                    amount: transaction.amount,
                    category: transaction.type.category?.rawValue
                )
                analyticsService.trackEvent(transactionEvent)
            } catch {
                let errorEvent = ErrorEvent(error: error, context: "add_transaction")
                analyticsService.trackEvent(errorEvent)
            }
        }
    }

    func addIncome(_ amount: Double) {
        let incomeTransaction = Transaction(amount: amount, type: .income)
        addTransaction(incomeTransaction)
    }
    
    func loadNextPage() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        Task {
            do {
                let offset = currentPage * pageSize
                let newTransactions = try store.fetchTransactions(limit: pageSize, offset: offset)
                
                await MainActor.run {
                    self.allTransactions.append(contentsOf: newTransactions)
                    self.currentPage += 1
                    self.isLoading = false
                    self.updateTransactionGroups()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
                let errorEvent = ErrorEvent(error: error, context: "load_next_page")
                analyticsService.trackEvent(errorEvent)
            }
        }
    }
    
    private func loadInitialTransactions() {
        do {
            let initialTransactions = try store.fetchTransactions(limit: pageSize, offset: 0)
            allTransactions = initialTransactions
            currentPage = 1
            updateTransactionGroups()
        } catch {
            let errorEvent = ErrorEvent(error: error, context: "load_initial_transactions")
            analyticsService.trackEvent(errorEvent)
        }
    }
    
    private func loadCurrentBalance() {
        do {
            let currentBalance = try store.getCurrentBalance()
            balanceSubject.send(currentBalance)
        } catch {
            let errorEvent = ErrorEvent(error: error, context: "load_current_balance")
            analyticsService.trackEvent(errorEvent)
        }
    }
    
    private func updateBalanceAfterTransaction(_ transaction: Transaction) async {
        do {
            let currentBalance = try store.getCurrentBalance()
            let newBalance: Double
            
            switch transaction.type {
            case .income:
                newBalance = currentBalance + transaction.amount
            case .expense:
                newBalance = currentBalance - transaction.amount
            }
            
            try store.updateBalance(newBalance)
            
            await MainActor.run {
                self.balanceSubject.send(newBalance)
            }
        } catch {
            let errorEvent = ErrorEvent(error: error, context: "update_balance_after_transaction")
            analyticsService.trackEvent(errorEvent)
        }
    }
    
    private func reloadTransactionsForCurrentPage() async {
        do {
            let currentTransactions = try store.fetchTransactions(limit: pageSize, offset: 0)
            await MainActor.run {
                self.allTransactions = currentTransactions
                self.currentPage = 1
                self.updateTransactionGroups()
            }
        } catch {
            print("Error reloading transactions for current page: \(error)")
        }
    }
    
    private func updateTransactionGroups() {
        let groupedTransactions = Dictionary(grouping: allTransactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
        
        let sortedGroups = groupedTransactions.map { date, transactions in
            TransactionGroup(date: date, transactions: transactions.sorted { $0.date > $1.date })
        }.sorted { $0.date > $1.date }
        
        transactionGroupsSubject.send(sortedGroups)
    }
}
