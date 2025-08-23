//
//  MockNetworkReachability.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation
import Combine
@testable import TransactionsTestTask

final class MockNetworkReachability: NetworkReachability {
    var mockIsConnected = true
    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(false)
    
    var isConnected: Bool {
        mockIsConnected
    }
    
    var connectionStatusPublisher: AnyPublisher<Bool, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
    
    func simulateNetworkChange(isConnected: Bool) {
        mockIsConnected = isConnected
        connectionStatusSubject.send(isConnected)
    }
}
