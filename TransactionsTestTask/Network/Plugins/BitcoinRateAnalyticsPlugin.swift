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
                let response = try JSONDecoder().decode(BitcoinRateResponse.self, from: data)
                let rate = response.USD.last
                
                analyticsService.trackEvent(
                    name: "bitcoin_rate_update",
                    parameters: [
                        "rate": String(format: "%.2f", rate),
                        "currency": "USD",
                        "source": "network_layer"
                    ]
                )
            } catch {
                // If decoding fails, still track the event but without rate data
                analyticsService.trackEvent(
                    name: "bitcoin_rate_update_failed",
                    parameters: [
                        "error": "decoding_error",
                        "source": "network_layer"
                    ]
                )
            }
            
        case .failure(let error):
            analyticsService.trackEvent(
                name: "bitcoin_rate_update_failed",
                parameters: [
                    "error": error.localizedDescription,
                    "error_type": String(describing: type(of: error)),
                    "source": "network_layer"
                ]
            )
        }
    }
}
