//
//  TransactionTableViewCell.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 09/03/23.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var payee: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
