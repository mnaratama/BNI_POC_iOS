//
//  BenificiaryAddReviewView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//

import UIKit

class AddRecipientReviewDetailsView : UIViewController {
    
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientSuccessView = "AddRecipientSuccessVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientReviewDetailsView")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientSuccessView) as? AddRecipientSuccessView else {
            fatalError("Failed to load Transfer from AddRecipientSuccessVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
