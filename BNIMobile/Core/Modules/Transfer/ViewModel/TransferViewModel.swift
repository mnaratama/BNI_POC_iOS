//
//  TransferViewModel.swift
//  BNIMobile
//
//  Created by Naratama on 09/03/23.
//

import Foundation

class TransferViewModel{
    var receiversList: [Receivers]?
    
}

enum ChargeType {
    case beneficiary
    case guaranteed
}

class TransferConfirmationViewModel {
    var receiver: Receivers?
    var chargeType: ChargeType?
    var currencyConversion: CurrencyConverter?
}
