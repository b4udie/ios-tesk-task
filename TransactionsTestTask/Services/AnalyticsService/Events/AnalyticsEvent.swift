//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

struct AnalyticsEvent: AnalyticsEventProtocol {
    let name: String
    let parameters: [String: String]
    let date: Date
}
