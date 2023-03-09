//
//  CurrencyList.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currencyList = try? JSONDecoder().decode(CurrencyList.self, from: jsonData)

import Foundation

// MARK: - CurrencyList
struct CurrencyList: Codable {
    let currency: [Currency]
}

// MARK: - Currency
struct Currency: Codable {
    let currency: String
    let value: Double
    let countryCode, baseCountry: String
    let currencysymbol: JSONNull?
    let countryName: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
