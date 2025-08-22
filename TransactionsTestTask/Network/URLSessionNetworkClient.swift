//
//  URLSessionNetworkClient.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// URLSession-based implementation of NetworkClient
final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let queue: DispatchQueue
    var plugins: [NetworkPlugin] = []
    
    init(session: URLSession = .shared, queue: DispatchQueue = .global(qos: .background), plugins: [NetworkPlugin] = []) {
        self.session = session
        self.queue = queue
        self.plugins = plugins
    }
    
    func request(_ request: NetworkRequest) -> AnyPublisher<Data, NetworkError> {
        // Apply plugins to modify the request
        let modifiedRequest = applyPlugins(to: request)
        
        guard let url = modifiedRequest.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = modifiedRequest.method.rawValue
        urlRequest.httpBody = modifiedRequest.body
        
        // Add headers
        if let headers = modifiedRequest.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Notify plugins that request is about to be sent
        notifyPluginsWillSend(modifiedRequest)
        
        return session.dataTaskPublisher(for: urlRequest)
            .subscribe(on: queue)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
                
                return data
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.networkError(error)
                }
            }
            .handleEvents(
                receiveOutput: { [weak self] data in
                    self?.notifyPluginsDidReceive(.success(data), for: modifiedRequest)
                },
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.notifyPluginsDidReceive(.failure(error), for: modifiedRequest)
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}
