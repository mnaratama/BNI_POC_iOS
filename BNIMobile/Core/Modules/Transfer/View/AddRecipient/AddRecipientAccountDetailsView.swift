//
//  BenificiaryAddAcoount.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class AddRecipientAccountDetailsView : UIViewController {
    
    enum Constants {
        static let beneficiaryAddReviewVC = "BeneficiaryAddReviewVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Beneficiary Add Details View")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.beneficiaryAddReviewVC, bundle: nil).instantiateViewController(withIdentifier: Constants.beneficiaryAddReviewVC) as? AddRecipientReviewDetailsView else {
            fatalError("Failed to load Transfer from BenificiaryAddReviewVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
