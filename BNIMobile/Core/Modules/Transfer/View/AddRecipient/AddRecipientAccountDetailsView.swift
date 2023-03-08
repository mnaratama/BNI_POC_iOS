//
//  BenificiaryAddAcoount.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class AddRecipientAccountDetailsView : UIViewController {
    
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientBankDetailsView = "AddRecipientBankDetailsVC"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientAccountDetailsView")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientBankDetailsView) as? AddRecipientBankDetailsView else {
            fatalError("Failed to load Transfer from AddRecipientBankDetailsVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
