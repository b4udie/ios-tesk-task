//
//  BitcoinRateBO.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 24.08.2025.
//

import Foundation

struct BitcoinRateBO {
    let rate: Double
    let currency: String

    init(from dto: BitcoinRateDTO) {
        rate = dto.usd.last
        currency = dto.usd.symbol
    }
}
