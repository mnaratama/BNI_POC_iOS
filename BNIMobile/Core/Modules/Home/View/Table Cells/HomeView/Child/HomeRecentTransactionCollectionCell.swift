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
    
//    func bind(){
//        quicklinkView.layer.cornerRadius = 8
//        quicklinkView.layer.borderWidth = 1
//        quicklinkView.layer.borderColor = #colorLiteral(red: 0.9022675753, green: 0.9022675753, blue: 0.9022675753, alpha: 1)
//        quicklinkLabel.text = "SILVER"
//        imgView.image = UIImage(named: "GradientSilver")
//    }
}
