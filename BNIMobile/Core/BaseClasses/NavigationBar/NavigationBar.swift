//
//  NavigationBar.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 07/03/23.
//

import UIKit

class NavigationBar: UINavigationBar {

    override func draw(_ rect: CGRect) {
        // Drawing code
        let backImage = UIImage(named: "backButton")
        backIndicatorImage = backImage
        backIndicatorTransitionMaskImage = backImage
        backItem?.title = ""
        tintColor = .black
    }
}
