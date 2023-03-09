//
//  LandingPageTableViewCell.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

import UIKit

class LandingPageModalTableViewCell : UITableViewCell {
    
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var bankNamesWithAccountNumber: UILabel!
    @IBOutlet weak var countryNamesWithCurrency: UILabel!
    
    func bind(recipient: String, bankNames: String, countryNames: String){
        recipientName.text = recipient
        bankNamesWithAccountNumber.text = bankNames
        countryNamesWithCurrency.text = countryNames
    }
}
