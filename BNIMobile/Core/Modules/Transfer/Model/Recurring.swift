//
//  Recurring.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recurring = try? JSONDecoder().decode(Recurring.self, from: jsonData)

import Foundation

// MARK: - Recurring
struct Recurring: Codable {
    let transferID: Int
    let transferIDSetDate, senderAccountNumber, receiverAccountNumber, accountName: String
    let bankName, chargeType: String
    let transferCurrencyAmount: Int
    let frequency, bicCode, startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case transferID = "transferId"
        case transferIDSetDate = "transferIdSetDate"
        case senderAccountNumber, receiverAccountNumber, accountName, bankName, chargeType, transferCurrencyAmount, frequency, bicCode, startDate, endDate
    }
}
