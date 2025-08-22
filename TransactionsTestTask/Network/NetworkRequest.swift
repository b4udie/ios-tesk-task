//
//  NetworkRequest.swift
//  TransactionsTestTask
//
//

import Foundation

/// Protocol for network requests
protocol NetworkRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

/// Default implementation for NetworkRequest
extension NetworkRequest {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    /// Builds the full URL for the request
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        
        if let parameters = parameters, method == .get {
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        return components?.url
    }
}
