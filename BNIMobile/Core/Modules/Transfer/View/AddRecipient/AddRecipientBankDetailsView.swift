//
//  AddRecipientBankDetailsView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class AddRecipientBankDetailsView : UIViewController {
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientReviewDetailsView = "AddRecipientReviewDetailsVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientBankDetailsView")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientReviewDetailsView) as? AddRecipientReviewDetailsView else {
            fatalError("Failed to load Transfer from AddRecipientReviewDetailsVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
