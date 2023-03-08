//
//  HomeHeaderCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class HomeHeaderCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(){
        cardView.layer.shadowOffset = CGSize(width: 0.3,
                                                  height: 0.7)
        cardView.layer.shadowRadius = 1.3
        cardView.layer.shadowOpacity = 0.08
        imgView.image = UIImage(named: "img_card_green")
    }
}
