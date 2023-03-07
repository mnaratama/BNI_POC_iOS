//
//  ChooseRecipientView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//

import UIKit

class AddRecipientCountryView : UIViewController {
    
    enum Constants {
        static let beneficiaryAddDetailsVC = "Transfer"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Beneficiary Add Country View")
    }
    
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.beneficiaryAddDetailsVC, bundle: nil).instantiateViewController(withIdentifier: Constants.beneficiaryAddDetailsVC) as? AddRecipientAccountDetailsView else {
            fatalError("Failed to load Transfer from BenificiaryAddDetailsVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
