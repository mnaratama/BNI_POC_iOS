//
//  Transfer.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transfer = try? JSONDecoder().decode(Transfer.self, from: jsonData)

import Foundation

// MARK: - Transfer
struct Transfer: Codable {
    let senderAccountNo, recipientAccountNo, customerID: String
    let exchangeRate: Int
    let transferCurrencyAmount: Double
    let bicCode, bankName, baseCurrency, baseCurrencySymbol: String
    let foreignCurrency, foreignCurrencySymbol: String
    let amountInIDR, transferFees: Int
    let recipientReceivesAmount: Double
    let usePointToPay: Bool
    let chargeType, transferPurpose, agreement: String

    enum CodingKeys: String, CodingKey {
        case senderAccountNo, recipientAccountNo
        case customerID = "customerId"
        case exchangeRate, transferCurrencyAmount, bicCode, bankName, baseCurrency, baseCurrencySymbol, foreignCurrency, foreignCurrencySymbol, amountInIDR, transferFees, recipientReceivesAmount, usePointToPay, chargeType, transferPurpose, agreement
    }
}
