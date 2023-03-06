//
//  SuccessAddBeneficiaryView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class SuccessAddBeneficiaryView : UIViewController {
    
    enum Constants {
        static let mainStoryboardName = "Transfer"
        static let beneficiaryAddCountryVC = "Success"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Success Add Beneficiary View")
    }
    
    func buttonTappedToStart(_ sender : Any){
        guard let viewController = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.beneficiaryAddCountryVC) as? BenificiaryAddCountryView else {
            fatalError("Failed to load Transfer from BenificiaryAddCountryVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
