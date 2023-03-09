//
//  MySpaceClaimRewardCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class MySpaceClaimRewardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var claimRewardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(image: String, title: String){
        imgView.image = UIImage(named: image)
        claimRewardLabel.text = title
    }
}

