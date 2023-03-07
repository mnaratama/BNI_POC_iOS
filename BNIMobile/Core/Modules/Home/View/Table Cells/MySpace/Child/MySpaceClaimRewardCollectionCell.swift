//
//  MySpaceClaimRewardCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class MySpaceClaimRewardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var claimRewardView: UIView!
    @IBOutlet weak var claimRewardLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(){
        claimRewardView.layer.cornerRadius = 8
        
        claimRewardView.layer.shadowOffset = CGSize(width: 0.2,
                                                  height: 0.7)
        claimRewardView.layer.shadowRadius = 1.3
        claimRewardView.layer.shadowOpacity = 0.3
        pointLabel.text = "1500 pt"
        claimRewardLabel.text = "IDR 100,000 Steam Voucher"
        imgView.image = UIImage(named: "img_starbuck")
    }
}

