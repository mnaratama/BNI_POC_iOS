//
//  ManageQuicklinkCollectionCell.swift
//  BNIMobile
//
//  Created by Naratama on 09/03/23.
//

import UIKit

class ManageQuicklinkCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var quicklinkLabel: UILabel!
    @IBOutlet weak var quicklinkView: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind(image: String, title: String){
        imgView.image = UIImage(named: image)
        quicklinkLabel.text = title
//        imgClose.image = UIImage(named: image)
    }
}
