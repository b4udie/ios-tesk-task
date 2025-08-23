//
//  MockBitcoinRateNetworkService.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation
import Combine
@testable import TransactionsTestTask

final class MockBitcoinRateNetworkService: BitcoinRateNetworkService {
    var mockResponse: BitcoinRateResponse?
    var mockError: NetworkError?
    var fetchBitcoinRateCallCount = 0
    
    func fetchBitcoinRate() -> AnyPublisher<TransactionsTestTask.BitcoinRateResponse, TransactionsTestTask.NetworkError> {
        fetchBitcoinRateCallCount += 1
        
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let response = mockResponse {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }
    }
}
