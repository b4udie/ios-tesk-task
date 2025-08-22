//
//  BitcoinAPI.swift
//  TransactionsTestTask
//
//

enum BitcoinAPI {
    case ticker
}

extension BitcoinAPI: NetworkRequest {
    var baseURL: String {
        switch self {
        case .ticker:
            "https://blockchain.info"
        }
    }
    
    var path: String {
        switch self {
        case .ticker:
            "/ticker"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
}
