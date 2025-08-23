//
//  MockTransactionStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

@testable import TransactionsTestTask

final class MockTransactionStore: TransactionStore {
    var mockTransactions: [Transaction] = []
    var mockTotalCount: Int = 0
    var mockCurrentBalance: Double = 0.0
    var mockError: Error?
    var fetchTotalCountError: Error?
    var loadBalanceError: Error?
    
    var insertCallCount = 0
    var insertLastTransaction: Transaction?
    var fetchTransactionsCallCount = 0
    var fetchTransactionsLastLimit: Int = 0
    var fetchTransactionsLastOffset: Int = 0
    var fetchTotalCountCallCount = 0
    var getCurrentBalanceCallCount = 0
    var updateBalanceCallCount = 0
    var reloadTransactionsForCurrentPageCallCount = 0
    
    func insert(_ transaction: Transaction) async throws {
        insertCallCount += 1
        insertLastTransaction = transaction
        
        if let error = mockError {
            throw error
        }
    }
    
    func fetchTransactions(limit: Int, offset: Int) throws -> [Transaction] {
        fetchTransactionsCallCount += 1
        fetchTransactionsLastLimit = limit
        fetchTransactionsLastOffset = offset
        
        if let error = mockError {
            throw error
        }

        return mockTransactions
    }
    
    func fetchTotalCount() throws -> Int {
        fetchTotalCountCallCount += 1
        
        if let error = fetchTotalCountError {
            throw error
        }
        
        return mockTotalCount
    }
    
    func getCurrentBalance() throws -> Double {
        getCurrentBalanceCallCount += 1
        
        if let error = loadBalanceError {
            throw error
        }
        
        return mockCurrentBalance
    }
    
    func updateBalance(_ newBalance: Double) throws {
        updateBalanceCallCount += 1
    
        if let error = mockError {
            throw error
        }
        
        mockCurrentBalance = newBalance
    }
}
