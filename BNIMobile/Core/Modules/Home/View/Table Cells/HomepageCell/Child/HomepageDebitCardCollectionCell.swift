//
//  HomepageDebitCardCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class HomepageDebitCardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNominalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(cardName: String, cardNominal: String){
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0.2,
                                             height: 0.7)
        cardView.layer.shadowRadius = 1.3
        cardView.layer.shadowOpacity = 0.3
        imgView.image = UIImage(named: "img_card_green")
        
        cardNameLabel.text = cardName
        cardNominalLabel.text = cardNominal
    }
}
