//
//  BenificiaryAddReviewView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//

import UIKit

class AddRecipientReviewDetailsView : UIViewController {
    
    enum Constants {
        static let mainStoryboardName = "Transfer"
        static let successAddBeneficiaryVC = "SuccessAddBeneficiaryVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Beneficiary Add Review View")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.successAddBeneficiaryVC) as? AddRecipientSuccessView else {
            fatalError("Failed to load Transfer from SuccessAddBeneficiaryVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
