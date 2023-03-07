//
//  HomeQuicklinksCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeQuicklinksCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var quicklinkView: UIView!
    @IBOutlet weak var quicklinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(){
        quicklinkView.layer.cornerRadius = 8
        quicklinkView.layer.borderWidth = 1
        quicklinkView.layer.borderColor = #colorLiteral(red: 0.9022675753, green: 0.9022675753, blue: 0.9022675753, alpha: 1)
        
        quicklinkView.layer.shadowOffset = CGSize(width: 0.3,
                                                  height: 0.7)
        quicklinkView.layer.shadowRadius = 1.3
        quicklinkView.layer.shadowOpacity = 0.08
        quicklinkLabel.text = "SILVER"
        imgView.image = UIImage(named: "GradientSilver")
    }
}

