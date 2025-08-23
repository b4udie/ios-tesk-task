//
//  MockAnalyticsService.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation
@testable import TransactionsTestTask

final class MockAnalyticsService: AnalyticsService {
    var trackedEvents: [AnalyticsEvent] = []
    var trackedErrorEvents: [ErrorEvent] = []
    var trackedBitcoinRateEvents: [BitcoinRateEvent] = []
    var trackedTransactionEvents: [TransactionEvent] = []
    
    func trackEvent(_ event: AnalyticsEventProtocol) {
        trackedEvents.append(AnalyticsEvent(
            name: event.name,
            parameters: event.parameters,
            date: event.date
        ))
        
        if let errorEvent = event as? ErrorEvent {
            trackedErrorEvents.append(errorEvent)
        } else if let bitcoinEvent = event as? BitcoinRateEvent {
            trackedBitcoinRateEvents.append(bitcoinEvent)
        } else if let transactionEvent = event as? TransactionEvent {
            trackedTransactionEvents.append(transactionEvent)
        }
    }
    
    func trackEvent(name: String, parameters: [String: String]) {
        trackedEvents.append(AnalyticsEvent(name: name, parameters: parameters, date: .now))
    }
    
    func getEvents(name: String?, from: Date?, to: Date?) -> [AnalyticsEvent] {
        return trackedEvents
    }
    
    func clearEvents() {
        trackedEvents.removeAll()
        trackedErrorEvents.removeAll()
        trackedBitcoinRateEvents.removeAll()
        trackedTransactionEvents.removeAll()
    }
}
