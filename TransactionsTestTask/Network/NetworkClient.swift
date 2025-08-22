//
//  NetworkClient.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// Protocol for network client
protocol NetworkClient {
    var plugins: [NetworkPlugin] { get set }

    func request<T: Decodable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError>
    func request(_ request: NetworkRequest) -> AnyPublisher<Data, NetworkError>
}

/// Default implementation for NetworkClient
extension NetworkClient {
    func request<T: Decodable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError> {
        return self.request(request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Apply plugins to the request
    func applyPlugins(to request: NetworkRequest) -> NetworkRequest {
        var modifiedRequest = request
        for plugin in plugins {
            modifiedRequest = plugin.prepare(modifiedRequest)
        }
        return modifiedRequest
    }
    
    /// Notify plugins about request start
    func notifyPluginsWillSend(_ request: NetworkRequest) {
        for plugin in plugins {
            plugin.willSend(request)
        }
    }
    
    /// Notify plugins about request completion
    func notifyPluginsDidReceive(_ result: Result<Data, NetworkError>, for request: NetworkRequest) {
        for plugin in plugins {
            plugin.didReceive(result, for: request)
        }
    }
}
