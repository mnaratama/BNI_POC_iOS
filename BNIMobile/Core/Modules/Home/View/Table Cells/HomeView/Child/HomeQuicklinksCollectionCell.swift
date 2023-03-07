//
//  HomeQuicklinksCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeQuicklinksCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var quicklinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(){
        quicklinkLabel.text = "Top up & payment"
        imgView.image = UIImage(named: "ic_optimize_cashflow")
    }
}

