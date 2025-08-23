//
//  MockTransactionStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class BitcoinRateServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitializationWithCachedRate() {
        // Given
        let expectedRate = 45000.0
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = expectedRate
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        let mockNetworkReachability = MockNetworkReachability()
        
        // When
        let _ = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        // Then
        XCTAssertEqual(mockBitcoinRateStore.getCurrentRateCallCount, 1)
    }
    
    // MARK: - Rate Publisher Tests
    
    func testRatePublisherEmitsCachedRateOnInit() {
        // Given
        let expectedRate = 44000.0
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = expectedRate
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        let mockNetworkReachability = MockNetworkReachability()
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Rate published")
        var receivedRate: Double = 0.0
        
        // When
        bitcoinRateService.ratePublisher
            .sink { rate in
                receivedRate = rate
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedRate, expectedRate)
    }
    
    func testRatePublisherEmitsZeroWhenNoCachedRate() {
        // Given
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = nil
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        let mockNetworkReachability = MockNetworkReachability()
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Rate published")
        var receivedRate: Double = 0.0
        
        // When
        bitcoinRateService.ratePublisher
            .sink { rate in
                receivedRate = rate
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedRate, 0.0) // Default value
    }
    
    // MARK: - Network Reachability Tests
    
    func testRatePublisherUpdatesWhenNetworkBecomesAvailable() {
        // Given
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = 44000.0
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = false
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Network reconnection handled")
        expectation.expectedFulfillmentCount = 2 // Initial rate + network reconnection
        
        var receivedRates: [Double] = []
        
        bitcoinRateService.ratePublisher
            .sink { rate in
                receivedRates.append(rate)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - simulate network becoming available
        mockNetworkReachability.simulateNetworkChange(isConnected: true)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(mockNetworkService.fetchBitcoinRateCallCount, 1)
    }
    
    func testRatePublisherDoesNotFetchWhenNetworkUnavailable() {
        // Given
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = 44000.0
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = false
        
        // When
        let _ = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        // Then
        XCTAssertEqual(mockNetworkService.fetchBitcoinRateCallCount, 0)
    }
    
    // MARK: - Network Response Tests
    
    func testRatePublisherUpdatesOnSuccessfulNetworkResponse() {
        // Given
        let cachedRate = 44000.0
        let networkRate = 45000.0
        
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = cachedRate
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        mockNetworkService.mockResponse = BitcoinRateResponse(USD: .init(last: networkRate, symbol: "$"))
        
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = true
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Rate updated from network")
        expectation.expectedFulfillmentCount = 2 // Initial cached rate + network rate
        
        var receivedRates: [Double] = []
        
        bitcoinRateService.ratePublisher
            .sink { rate in
                receivedRates.append(rate)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - trigger network fetch by simulating network availability
        mockNetworkReachability.simulateNetworkChange(isConnected: true)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedRates.count, 2)
        XCTAssertEqual(receivedRates.first, cachedRate) // Initial cached rate
        XCTAssertEqual(receivedRates.last, networkRate) // Updated network rate
        XCTAssertEqual(mockBitcoinRateStore.saveRateCallCount, 1)
        XCTAssertEqual(mockBitcoinRateStore.lastSavedRate, networkRate)
    }
    
    func testRatePublisherHandlesNetworkError() {
        // Given
        let cachedRate = 44000.0
        let networkError = NetworkError.invalidResponse
        
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = cachedRate
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        mockNetworkService.mockError = networkError
        
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = true
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Error handled")
        expectation.expectedFulfillmentCount = 2 // Only initial cached rate
        
        var receivedRates: [Double] = []
        
        bitcoinRateService.ratePublisher
            .sink { rate in
                receivedRates.append(rate)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - trigger network fetch by simulating network availability
        mockNetworkReachability.simulateNetworkChange(isConnected: true)
                
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedRates.count, 2) // Initially cached rate + cached when error occured
        XCTAssertEqual(receivedRates.first, cachedRate)
        XCTAssertEqual(receivedRates.last, cachedRate)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "bitcoin_rate_fetch")
    }
    
    // MARK: - Analytics Integration Tests
        
    func testAnalyticsTrackedOnError() {
        // Given
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = 44000.0
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        mockNetworkService.mockError = NetworkError.invalidResponse
        
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = true
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Error analytics tracked")
        expectation.expectedFulfillmentCount = 2
        
        bitcoinRateService.ratePublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - trigger network fetch
        mockNetworkReachability.simulateNetworkChange(isConnected: true)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService.trackedErrorEvents.first?.context, "bitcoin_rate_fetch")
    }
    
    // MARK: - Store Integration Tests
    
    func testStoreSaveRateCalledOnSuccessfulNetworkResponse() {
        // Given
        let mockBitcoinRateStore = MockBitcoinRateStore()
        mockBitcoinRateStore.mockCurrentRate = 44000.0
        
        let mockAnalyticsService = MockAnalyticsService()
        let mockNetworkService = MockBitcoinRateNetworkService()
        mockNetworkService.mockResponse = BitcoinRateResponse(USD: .init(last: 45000.0, symbol: "$"))
        
        let mockNetworkReachability = MockNetworkReachability()
        mockNetworkReachability.mockIsConnected = true
        
        let bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            networkService: mockNetworkService,
            networkReachability: mockNetworkReachability,
            bitcoinRateStore: mockBitcoinRateStore
        )
        
        let expectation = XCTestExpectation(description: "Store save called")
        expectation.expectedFulfillmentCount = 2

        bitcoinRateService.ratePublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - trigger network fetch
        mockNetworkReachability.simulateNetworkChange(isConnected: true)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(mockBitcoinRateStore.saveRateCallCount, 1)
        XCTAssertEqual(mockBitcoinRateStore.lastSavedRate, 45000.0)
    }
}
