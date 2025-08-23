//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

protocol AnalyticsService: AnyObject {
    func trackEvent(_ event: AnalyticsEventProtocol)
    func trackEvent(name: String, parameters: [String: String])
    func getEvents(name: String?, from: Date?, to: Date?) -> [AnalyticsEvent]
    func clearEvents()
}

final class AnalyticsServiceImpl: AnalyticsService {
    private let queue = DispatchQueue(label: "analytics.service.queue", qos: .utility)
    private var events: [AnalyticsEvent] = []

    func trackEvent(_ event: AnalyticsEventProtocol) {
        let analyticsEvent = AnalyticsEvent(
            name: event.name,
            parameters: event.parameters,
            date: event.date
        )

        queue.async { [weak self] in
            self?.events.append(analyticsEvent)
            print("📊 Analytics:", analyticsEvent.name, "-", analyticsEvent.parameters)
        }
    }

    func trackEvent(name: String, parameters: [String: String]) {
        trackEvent(AnalyticsEvent(name: name, parameters: parameters, date: .now))
    }

    func getEvents(name: String?, from: Date?, to: Date?) -> [AnalyticsEvent] {
        queue.sync {
            events.filter { e in
                (name == nil || e.name == name!) &&
                (from == nil || e.date >= from!) &&
                (to == nil || e.date <= to!)
            }
        }
    }

    func clearEvents() {
        queue.async { [weak self] in
            self?.events.removeAll()
        }
    }
}
