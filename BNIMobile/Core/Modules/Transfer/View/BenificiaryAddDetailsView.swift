//
//  BenificiaryAddAcoount.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class BeneficiaryAddDetailsView : UIViewController {
    
    enum Constants {
        static let beneficiaryAddReviewVC = "BeneficiaryAddReviewVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Beneficiary Add Details View")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.beneficiaryAddReviewVC, bundle: nil).instantiateViewController(withIdentifier: Constants.beneficiaryAddReviewVC) as? BeneficiaryAddReviewView else {
            fatalError("Failed to load Transfer from BenificiaryAddReviewVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
