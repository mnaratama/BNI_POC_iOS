//
//  AddRecipientView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//


import UIKit

class AddRecipientView : UIViewController {
    
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientCountryView = "AddRecipientCountryVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientTermAndConditionView")
    }
    
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientCountryView) as? AddRecipientCountryView else {
            fatalError("Failed to load Transfer from AddRecipientCountryVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
