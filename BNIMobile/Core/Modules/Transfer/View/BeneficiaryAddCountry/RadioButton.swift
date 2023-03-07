//
//  RadioButton.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class RadioButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_radio_button")! as UIImage
    let uncheckedImage = UIImage(named: "ic_radio_button_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
