//
//  BitcoinRateAnalyticsPlugin.swift
//  TransactionsTestTask
//
//

import Foundation

/// Plugin for tracking Bitcoin rate analytics specifically
final class BitcoinRateAnalyticsPlugin: NetworkPlugin {
    private let analyticsService: AnalyticsService
    
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }
    
    func didReceive(_ result: Result<Data, NetworkError>, for request: NetworkRequest) {
        // Only track Bitcoin rate requests
        guard request.path.contains(BitcoinAPI.ticker.path) else { return }
        
        switch result {
        case .success(let data):
            // Try to decode and track the Bitcoin rate
            do {
                let response = try JSONDecoder().decode(BitcoinRateDTO.self, from: data)
                let bitcoinEvent = BitcoinRateEvent(rate: response.usd.last)
                analyticsService.trackEvent(bitcoinEvent)
            } catch {
                let errorEvent = ErrorEvent(error: error, context: "bitcoin_rate_decoding")
                analyticsService.trackEvent(errorEvent)
            }
            
        case .failure(let error):
            let errorEvent = ErrorEvent(error: error, context: "bitcoin_rate_network")
            analyticsService.trackEvent(errorEvent)
        }
    }
}
