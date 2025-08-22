//
//  NetworkPlugin.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// Protocol for network plugins
protocol NetworkPlugin {
    /// Called before the request is sent
    func prepare(_ request: NetworkRequest) -> NetworkRequest
    
    /// Called when the request is about to be sent
    func willSend(_ request: NetworkRequest)
    
    /// Called when the request completes successfully
    func didReceive(_ result: Result<Data, NetworkError>, for request: NetworkRequest)
    
    /// Called when the request completes with an error
    func didReceive(_ error: NetworkError, for request: NetworkRequest)
}

/// Default implementation for NetworkPlugin
extension NetworkPlugin {
    func prepare(_ request: NetworkRequest) -> NetworkRequest {
        return request
    }
    
    func willSend(_ request: NetworkRequest) {
        // Default implementation does nothing
    }
    
    func didReceive(_ result: Result<Data, NetworkError>, for request: NetworkRequest) {
        // Default implementation does nothing
    }
    
    func didReceive(_ error: NetworkError, for request: NetworkRequest) {
        // Default implementation does nothing
    }
}
