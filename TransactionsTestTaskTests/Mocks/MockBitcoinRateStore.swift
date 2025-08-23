//
//  MockBitcoinRateStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation
@testable import TransactionsTestTask

final class MockBitcoinRateStore: BitcoinRateStore {
    var mockCurrentRate: Double?
    var mockError: Error?
    var saveRateCallCount = 0
    var getCurrentRateCallCount = 0
    var lastSavedRate: Double?
    
    func saveRate(_ rate: Double) async throws {
        saveRateCallCount += 1
        lastSavedRate = rate
        
        if let error = mockError {
            throw error
        }
    }
    
    func getCurrentRate() throws -> Double? {
        getCurrentRateCallCount += 1
        
        if let error = mockError {
            throw error
        }
        
        return mockCurrentRate
    }
}
