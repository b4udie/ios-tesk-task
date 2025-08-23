//
//  BitcoinRateDTO.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 24.08.2025.
//

import Foundation

struct BitcoinRateDTO: Decodable {
    struct CurrencyRateDTO: Decodable {
        let last: Double
        let symbol: String
    }

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }

    let usd: CurrencyRateDTO
}
