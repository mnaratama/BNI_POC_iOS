//
//  CurrencyConverter.swift
//  BNIMobile
//
//  Created by Mukunda Marthy on 10/03/23.
//

import Foundation

class CurrencyConverter {
    var exchangeRate: CGFloat = 0.0
    var sourceAmount: CGFloat = 0.0
    var destinationAmount: CGFloat = 0.0
    var transferFeePercentage: CGFloat = 2.0
    var totalFee: CGFloat = 0.0
    var chargeType: ChargeType?
    var sourceCurrencyCode: String = "", destinationCurrencyCode: String = ""
    var currency: Currency?
    func calculateDestinationAmount() -> CGFloat {
        if currency?.baseCountry == "IDR" {
            destinationAmount = sourceAmount / exchangeRate
        } else {
            destinationAmount = sourceAmount * exchangeRate
        }
        return destinationAmount
    }
    
    func calculateTotal() -> CGFloat {
        return chargeType == .beneficiary ? (sourceAmount - (transferFeePercentage*sourceAmount/100)) : (sourceAmount + (transferFeePercentage*sourceAmount/100))
    }
    
    func calculateRecipientAmount() -> CGFloat {
        return chargeType == .beneficiary ? (sourceAmount - (transferFeePercentage*sourceAmount/100)) / exchangeRate : destinationAmount
    }
    
    func getCurrencySymbol(code: String) -> String {
        return Locale(identifier: code).currencySymbol ?? ""
    }
    
}
