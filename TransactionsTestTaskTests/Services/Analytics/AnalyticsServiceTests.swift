//
//  MockTransactionStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
    
    var analyticsService: AnalyticsService!
    
    override func setUp() {
        super.setUp()
        analyticsService = AnalyticsServiceImpl()
    }
    
    override func tearDown() {
        analyticsService = nil
        super.tearDown()
    }
    
    // MARK: - Track Event Tests
    
    func testTrackEventWithNameAndParameters() {
        // Given
        let eventName = "test_event"
        let parameters = ["key1": "value1", "key2": "value2"]
        
        // When
        analyticsService.trackEvent(name: eventName, parameters: parameters)
        
        // Then
        let events = analyticsService.getEvents(name: eventName, from: nil, to: nil)
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, eventName)
        XCTAssertEqual(events.first?.parameters, parameters)
    }
    
    func testTrackEventWithProtocol() {
        // Given
        let error = NSError(domain: "TestDomain", code: 123, userInfo: nil)
        let errorEvent = ErrorEvent(error: error, context: "test_context")
        
        // When
        analyticsService.trackEvent(errorEvent)
        
        // Then
        let events = analyticsService.getEvents(name: "error_occurred", from: nil, to: nil)
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.parameters["error_code"], "123")
        XCTAssertEqual(events.first?.parameters["context"], "test_context")
    }
    
    func testTrackMultipleEvents() {
        // Given
        let event1 = AnalyticsEvent(name: "event1", parameters: ["param": "value1"], date: Date())
        let event2 = AnalyticsEvent(name: "event2", parameters: ["param": "value2"], date: Date())
        
        // When
        analyticsService.trackEvent(event1)
        analyticsService.trackEvent(event2)
        
        // Then
        let allEvents = analyticsService.getEvents(name: nil, from: nil, to: nil)
        XCTAssertEqual(allEvents.count, 2)
    }
    
    // MARK: - Get Events Tests
    
    func testGetEventsByName() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: [:])
        analyticsService.trackEvent(name: "event2", parameters: [:])
        analyticsService.trackEvent(name: "event1", parameters: [:])
        
        // When
        let event1Events = analyticsService.getEvents(name: "event1", from: nil, to: nil)
        let event2Events = analyticsService.getEvents(name: "event2", from: nil, to: nil)
        
        // Then
        XCTAssertEqual(event1Events.count, 2)
        XCTAssertEqual(event2Events.count, 1)
    }
    
    func testGetEventsByDateRange() {
        // Given
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3600)
        let twoHoursAgo = now.addingTimeInterval(-7200)
        
        let oldEvent = AnalyticsEvent(name: "old", parameters: [:], date: twoHoursAgo)
        let recentEvent = AnalyticsEvent(name: "recent", parameters: [:], date: oneHourAgo)
        let currentEvent = AnalyticsEvent(name: "current", parameters: [:], date: now)
        
        analyticsService.trackEvent(oldEvent)
        analyticsService.trackEvent(recentEvent)
        analyticsService.trackEvent(currentEvent)
        
        // When
        let recentEvents = analyticsService.getEvents(name: nil, from: oneHourAgo, to: now)
        
        // Then
        XCTAssertEqual(recentEvents.count, 2)
        XCTAssertTrue(recentEvents.allSatisfy { $0.name == "recent" || $0.name == "current" })
    }
    
    func testGetEventsWithNilFilters() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: [:])
        analyticsService.trackEvent(name: "event2", parameters: [:])
        
        // When
        let allEvents = analyticsService.getEvents(name: nil, from: nil, to: nil)
        
        // Then
        XCTAssertEqual(allEvents.count, 2)
    }
    
    // MARK: - Clear Events Tests
    
    func testClearEvents() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: [:])
        analyticsService.trackEvent(name: "event2", parameters: [:])
        
        // When
        analyticsService.clearEvents()
        
        // Then
        let events = analyticsService.getEvents(name: nil, from: nil, to: nil)
        XCTAssertEqual(events.count, 0)
    }
    
    // MARK: - Thread Safety Tests
    
    func testConcurrentEventTracking() {
        // Given
        let expectation = XCTestExpectation(description: "Concurrent tracking completed")
        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
        let group = DispatchGroup()
        
        // When
        for i in 0..<100 {
            group.enter()
            queue.async {
                self.analyticsService.trackEvent(name: "event\(i)", parameters: ["index": "\(i)"])
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // Then
            let events = self.analyticsService.getEvents(name: nil, from: nil, to: nil)
            XCTAssertEqual(events.count, 100)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Event Types Tests
    
    func testErrorEventParameters() {
        // Given
        let error = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let errorEvent = ErrorEvent(error: error, context: "test_context")
        
        // When
        analyticsService.trackEvent(errorEvent)
        
        // Then
        let events = analyticsService.getEvents(name: "error_occurred", from: nil, to: nil)
        let event = events.first
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.parameters["error_domain"], "TestDomain")
        XCTAssertEqual(event?.parameters["error_code"], "999")
        XCTAssertEqual(event?.parameters["error_description"], "Test error")
        XCTAssertEqual(event?.parameters["context"], "test_context")
    }
    
    func testBitcoinRateEventParameters() {
        // Given
        let bitcoinEvent = BitcoinRateEvent(rate: 45000.50)
        
        // When
        analyticsService.trackEvent(bitcoinEvent)
        
        // Then
        let events = analyticsService.getEvents(name: "bitcoin_rate_fetched", from: nil, to: nil)
        let event = events.first
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.parameters["rate"], "45000.50")
        XCTAssertEqual(event?.parameters["currency"], "USD")
    }
    
    func testTransactionEventParameters() {
        // Given
        let transactionEvent = TransactionEvent(type: "expense", amount: 100.0, category: "groceries")
        
        // When
        analyticsService.trackEvent(transactionEvent)
        
        // Then
        let events = analyticsService.getEvents(name: "transaction_added", from: nil, to: nil)
        let event = events.first
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.parameters["type"], "expense")
        XCTAssertEqual(event?.parameters["amount"], "100.00")
        XCTAssertEqual(event?.parameters["category"], "groceries")
    }
}
