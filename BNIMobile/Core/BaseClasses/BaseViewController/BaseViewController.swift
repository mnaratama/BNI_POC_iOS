//
//  BaseViewController.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 07/03/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleKeyboard()
    }
    
    func setCustomBackButton(imgName: String, target: AnyObject?, selector: Selector) {
        let backItem = UIBarButtonItem(image: UIImage(named: imgName), style: .plain, target: target, action: selector)
        backItem.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func handleKeyboard() {
        // To dismiss the keyboad when user taps outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
