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
    
    func bind(image: String, title: String){
        imgView.image = UIImage(named: image)
        quicklinkLabel.text = title
    }
}

