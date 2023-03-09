//
//  HomeRecentTransactionCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeRecentTransactionCollectionCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nominalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(transactionName: String, transactionNominal: String){
        nameLabel.text = transactionName
        nominalLabel.text = "-Rp \(transactionNominal)"
    }
}
