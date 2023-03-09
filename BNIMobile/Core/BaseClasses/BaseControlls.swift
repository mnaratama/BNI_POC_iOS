//
//  BaseControlls.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 08/03/23.
//

import UIKit

class RoundedView: UIView {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
    }

}

class RoundedStackView: UIStackView {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
    }

}
