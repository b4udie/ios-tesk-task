//
//  BitcoinRateNetworkService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// High-level network service that uses NetworkClient
protocol BitcoinRateNetworkService {
    func fetchBitcoinRate() -> AnyPublisher<BitcoinRateDTO, NetworkError>
}

/// Default implementation of NetworkService
final class BitcoinRateNetworkServiceImpl: BitcoinRateNetworkService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchBitcoinRate() -> AnyPublisher<BitcoinRateDTO, NetworkError> {
        networkClient.request(BitcoinAPI.ticker)
    }
}
