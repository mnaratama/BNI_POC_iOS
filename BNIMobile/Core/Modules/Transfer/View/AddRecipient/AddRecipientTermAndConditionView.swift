//
//  Term&ConditionView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class AddRecipientTermAndConditionView : UIViewController {
    
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientEnterPasswordView = "AddRecipientEnterPasswordVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientTermAndConditionView")
    }
    
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientEnterPasswordView) as? AddRecipientEnterPasswordView else {
            fatalError("Failed to load Transfer from AddRecipientEnterPasswordVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
