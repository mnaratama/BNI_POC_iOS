//
//  ReceiverList.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

import Foundation

struct ReceiverList : Codable {
    let success : Bool?
    let receivers : [Receivers]?
    let message : String?
    let error : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case receivers = "Receivers"
        case message = "message"
        case error = "error"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        receivers = try values.decodeIfPresent([Receivers].self, forKey: .receivers)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

struct Receivers : Codable {
    let id : Int?
    let payerAcNumber : String?
    let payerName : String?
    let payerBaseCurrency : String?
    let payerBaseCurrencySymbol : String?
    let receiverPaymentMode : String?
    let receiverCountryName : String?
    let receiverBankName : String?
    let receiverAcNumber : String?
    let receiverCityName : String?
    let receiverLocationName : String?
    let receiverCurrency : String?
    let receiverCurrencySymbol : String?
    let receiverName : String?
    let receiverAddressLine : String?
    let receiverType : String?
    let receiverAccountType : String?
    let swiftCode : String?
    let transferId : String?
    let agreement : String?
    let createdDate : String?
    let createdBy : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case payerAcNumber = "payerAcNumber"
        case payerName = "payerName"
        case payerBaseCurrency = "payerBaseCurrency"
        case payerBaseCurrencySymbol = "payerBaseCurrencySymbol"
        case receiverPaymentMode = "receiverPaymentMode"
        case receiverCountryName = "receiverCountryName"
        case receiverBankName = "receiverBankName"
        case receiverAcNumber = "receiverAcNumber"
        case receiverCityName = "receiverCityName"
        case receiverLocationName = "receiverLocationName"
        case receiverCurrency = "receiverCurrency"
        case receiverCurrencySymbol = "receiverCurrencySymbol"
        case receiverName = "receiverName"
        case receiverAddressLine = "receiverAddressLine"
        case receiverType = "receiverType"
        case receiverAccountType = "receiverAccountType"
        case swiftCode = "swiftCode"
        case transferId = "transferId"
        case agreement = "agreement"
        case createdDate = "createdDate"
        case createdBy = "createdBy"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        payerAcNumber = try values.decodeIfPresent(String.self, forKey: .payerAcNumber)
        payerName = try values.decodeIfPresent(String.self, forKey: .payerName)
        payerBaseCurrency = try values.decodeIfPresent(String.self, forKey: .payerBaseCurrency)
        payerBaseCurrencySymbol = try values.decodeIfPresent(String.self, forKey: .payerBaseCurrencySymbol)
        receiverPaymentMode = try values.decodeIfPresent(String.self, forKey: .receiverPaymentMode)
        receiverCountryName = try values.decodeIfPresent(String.self, forKey: .receiverCountryName)
        receiverBankName = try values.decodeIfPresent(String.self, forKey: .receiverBankName)
        receiverAcNumber = try values.decodeIfPresent(String.self, forKey: .receiverAcNumber)
        receiverCityName = try values.decodeIfPresent(String.self, forKey: .receiverCityName)
        receiverLocationName = try values.decodeIfPresent(String.self, forKey: .receiverLocationName)
        receiverCurrency = try values.decodeIfPresent(String.self, forKey: .receiverCurrency)
        receiverCurrencySymbol = try values.decodeIfPresent(String.self, forKey: .receiverCurrencySymbol)
        receiverName = try values.decodeIfPresent(String.self, forKey: .receiverName)
        receiverAddressLine = try values.decodeIfPresent(String.self, forKey: .receiverAddressLine)
        receiverType = try values.decodeIfPresent(String.self, forKey: .receiverType)
        receiverAccountType = try values.decodeIfPresent(String.self, forKey: .receiverAccountType)
        swiftCode = try values.decodeIfPresent(String.self, forKey: .swiftCode)
        transferId = try values.decodeIfPresent(String.self, forKey: .transferId)
        agreement = try values.decodeIfPresent(String.self, forKey: .agreement)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
    }

}
