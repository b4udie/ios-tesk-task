//
//  MockTransactionStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class TransactionServiceTests: XCTestCase {
    
    var transactionService: TransactionServiceImpl!
    var mockTransactionStore: MockTransactionStore!
    var mockAnalyticsService: MockAnalyticsService!
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockTransactionStore = MockTransactionStore()
        mockAnalyticsService = MockAnalyticsService()
        cancellables = Set<AnyCancellable>()
        
        transactionService = TransactionServiceImpl(
            transactionStore: mockTransactionStore,
            analyticsService: mockAnalyticsService
        )
    }
    
    override func tearDown() {
        transactionService = nil
        mockTransactionStore = nil
        mockAnalyticsService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitializationLoadsInitialTransactions() {
        // Then
        XCTAssertEqual(mockTransactionStore.fetchTransactionsCallCount, 1)
        XCTAssertEqual(mockTransactionStore.fetchTransactionsLastLimit, 20)
        XCTAssertEqual(mockTransactionStore.fetchTransactionsLastOffset, 0)
    }
    
    func testInitializationLoadsCurrentBalance() {
        // Then
        XCTAssertEqual(mockTransactionStore.getCurrentBalanceCallCount, 1)
    }
    
    // MARK: - Add Transaction Tests
    
    func testAddTransactionSuccess() async {
        // Given
        let transaction = Transaction(amount: 100.0, type: .expense(.groceries))
        mockTransactionStore.mockError = nil
        
        // When
        transactionService.addTransaction(transaction)
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.insertCallCount, 1)
        XCTAssertEqual(mockTransactionStore.insertLastTransaction?.amount, 100.0)
        XCTAssertEqual(mockTransactionStore.updateBalanceCallCount, 1)
        XCTAssertEqual(mockTransactionStore.fetchTransactionsCallCount, 2)
        
        // Check analytics
        XCTAssertEqual(mockAnalyticsService.trackedTransactionEvents.count, 1)
        let trackedEvent = mockAnalyticsService.trackedTransactionEvents.first
        XCTAssertEqual(trackedEvent?.type, "expense")
        XCTAssertEqual(trackedEvent?.amount, 100.0)
        XCTAssertEqual(trackedEvent?.category, "groceries")
    }
    
    func testAddTransactionFailure() async {
        // Given
        let transaction = Transaction(amount: 100.0, type: .income)
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockTransactionStore.mockError = error
        
        // When
        transactionService.addTransaction(transaction)
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.insertCallCount, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "add_transaction")
    }
    
    func testAddIncomeTransaction() async {
        // Given
        let amount = 500.0
        mockTransactionStore.mockError = nil
        
        // When
        transactionService.addIncome(amount)
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.insertCallCount, 1)
        let insertedTransaction = mockTransactionStore.insertLastTransaction
        XCTAssertEqual(insertedTransaction?.amount, amount)
        XCTAssertEqual(insertedTransaction?.type.isIncome, true)
        
        // Check analytics
        XCTAssertEqual(mockAnalyticsService.trackedTransactionEvents.count, 1)
        let trackedEvent = mockAnalyticsService.trackedTransactionEvents.first
        XCTAssertEqual(trackedEvent?.type, "income")
        XCTAssertEqual(trackedEvent?.amount, amount)
        XCTAssertNil(trackedEvent?.category)
    }
    
    // MARK: - Pagination Tests
    
    func testLoadNextPageSuccess() async {
        // Given
        let newTransactions = [
            Transaction(amount: 50.0, type: .expense(.taxi)),
            Transaction(amount: 25.0, type: .expense(.restaurant))
        ]
        mockTransactionStore.mockTransactions = newTransactions
        mockTransactionStore.mockTotalCount = 25 // More than current page
        mockTransactionStore.mockError = nil
        
        // When
        transactionService.loadNextPage()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.fetchTransactionsCallCount, 2) // Initial + next page
        XCTAssertEqual(mockTransactionStore.fetchTransactionsLastLimit, 20)
        XCTAssertEqual(mockTransactionStore.fetchTransactionsLastOffset, 20) // currentPage * pageSize = 1 * 20 = 20
    }
    
    func testLoadNextPageFailure() async {
        // Given
        let newTransactions = [
            Transaction(amount: 50.0, type: .expense(.taxi)),
            Transaction(amount: 25.0, type: .expense(.restaurant))
        ]
        mockTransactionStore.mockTransactions = newTransactions
        mockTransactionStore.mockTotalCount = 25 // More than current page
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockTransactionStore.mockError = error

        // When
        transactionService.loadNextPage()

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "load_next_page")
    }
    
    func testHasMorePages() {
        // Given
        mockTransactionStore.mockTotalCount = 65 // 3 pages of 20 items
        
        // When
        let hasMore = transactionService.hasMorePages
        
        // Then
        XCTAssertTrue(hasMore)
        XCTAssertEqual(mockTransactionStore.fetchTotalCountCallCount, 1)
    }
    
    func testNoMorePages() {
        // Given
        mockTransactionStore.mockTotalCount = 5 // Less than page size
        
        // When
        let hasMore = transactionService.hasMorePages
        
        // Then
        XCTAssertFalse(hasMore)
    }
    
    // MARK: - Balance Tests
    
    func testUpdateBalanceAfterTransaction() async {
        // Given
        let transaction = Transaction(amount: 100.0, type: .income)
        mockTransactionStore.mockCurrentBalance = 500.0
        mockTransactionStore.mockError = nil
        
        // When
        transactionService.addTransaction(transaction)
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.updateBalanceCallCount, 1)
    }
    
    func testUpdateBalanceAfterExpense() async {
        // Given
        let transaction = Transaction(amount: 50.0, type: .expense(.groceries))
        mockTransactionStore.mockCurrentBalance = 100.0
        mockTransactionStore.mockError = nil
        
        // When
        transactionService.addTransaction(transaction)
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockTransactionStore.updateBalanceCallCount, 1)
    }
    
    // MARK: - Publishers Tests
    
    func testTransactionsPublisher() {
        // Given
        let expectation = XCTestExpectation(description: "Transactions published")
        var receivedGroups: [TransactionGroup] = []
        let newTransactions = [
            Transaction(amount: 50.0, type: .expense(.taxi)),
            Transaction(amount: 25.0, type: .expense(.restaurant))
        ]

        mockTransactionStore.mockTransactions = newTransactions
        mockTransactionStore.mockTotalCount = 25 // More than current page
        mockTransactionStore.mockError = nil

        transactionService.transactionsPublisher
            .dropFirst()
            .sink { groups in
                receivedGroups = groups
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        transactionService.loadNextPage()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(receivedGroups.isEmpty)
    }
    
    func testBalancePublisher() {
        // Given
        let expectation = XCTestExpectation(description: "Balance published")
        var receivedBalance: Double = 0.0
        
        transactionService.balancePublisher
            .sink { balance in
                receivedBalance = balance
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        // Service is already initialized and should publish initial balance
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedBalance, mockTransactionStore.mockCurrentBalance)
    }
    
    // MARK: - Error Handling Tests
    
    func testLoadInitialTransactionsError() {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockTransactionStore.mockError = error
        
        // When
        let _ = TransactionServiceImpl(
            transactionStore: mockTransactionStore,
            analyticsService: mockAnalyticsService
        )
        
        // Then
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "load_initial_transactions")
    }
    
    func testLoadCurrentBalanceError() {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockTransactionStore.loadBalanceError = error
        
        // When
        let _ = TransactionServiceImpl(
            transactionStore: mockTransactionStore,
            analyticsService: mockAnalyticsService
        )
        
        // Then
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "load_current_balance")
    }
}
