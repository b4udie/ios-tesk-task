//
//  AnalyticsEventProtocol.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Foundation

protocol AnalyticsEventProtocol {
    var name: String { get }
    var parameters: [String: String] { get }
    var date: Date { get }
}
