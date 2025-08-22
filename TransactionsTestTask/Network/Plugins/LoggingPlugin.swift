//
//  LoggingPlugin.swift
//  TransactionsTestTask
//
//

import Foundation

/// Plugin for logging network requests and responses
final class LoggingPlugin: NetworkPlugin {
    private let logger: NetworkLogger
    
    init(logger: NetworkLogger = ConsoleNetworkLogger()) {
        self.logger = logger
    }
    
    func willSend(_ request: NetworkRequest) {
        logger.log("🌐 Sending request: \(request.method.rawValue) \(request.baseURL)\(request.path)")
        
        if let headers = request.headers {
            logger.log("📋 Headers: \(headers)")
        }
        
        if let parameters = request.parameters {
            logger.log("📝 Parameters: \(parameters)")
        }
        
        if let body = request.body {
            logger.log("📦 Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode")")
        }
    }
    
    func didReceive(_ result: Result<Data, NetworkError>, for request: NetworkRequest) {
        switch result {
        case .success(let data):
            logger.log("✅ Request succeeded: \(request.method.rawValue) \(request.baseURL)\(request.path)")
            logger.log("📄 Response data size: \(data.count) bytes")
            
            if let jsonString = String(data: data, encoding: .utf8) {
                logger.log("📄 Response: \(jsonString)")
            }
            
        case .failure(let error):
            logger.log("❌ Request failed: \(request.method.rawValue) \(request.baseURL)\(request.path)")
            logger.log("🚨 Error: \(error.localizedDescription)")
        }
    }
    
    func didReceive(_ error: NetworkError, for request: NetworkRequest) {
        logger.log("❌ Request failed: \(request.method.rawValue) \(request.baseURL)\(request.path)")
        logger.log("🚨 Error: \(error.localizedDescription)")
    }
}

/// Protocol for network logging
protocol NetworkLogger {
    func log(_ message: String)
}

/// Console implementation of NetworkLogger
final class ConsoleNetworkLogger: NetworkLogger {
    func log(_ message: String) {
        print("[NetworkLayer] \(message)")
    }
}
