//
//  RadioButton.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class RadioButton: UIImageView {
    // Images
    let checkedImage = UIImage(named: "ic_radio_button")! as UIImage
    let uncheckedImage = UIImage(named: "ic_radio_button_outline_blank")! as UIImage
    
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.image = checkedImage
            } else {
                self.image = uncheckedImage
            }
        }
    }
        
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        var gesture = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(sender:)))
        self.addGestureRecognizer(gesture)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
