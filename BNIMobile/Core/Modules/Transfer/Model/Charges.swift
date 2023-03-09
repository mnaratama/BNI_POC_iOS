//
//  Charges.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let charges = try? JSONDecoder().decode(Charges.self, from: jsonData)

import Foundation

// MARK: - Charges
struct Charges: Codable {
    let sendingCurrency, orderingCurrency: String
    let amountSendingCurrency: Int

    enum CodingKeys: String, CodingKey {
        case sendingCurrency = "sending_currency"
        case orderingCurrency = "ordering_currency"
        case amountSendingCurrency = "amount_sending_currency"
    }
}
