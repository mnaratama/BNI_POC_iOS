//
//  TransferSuccessView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class TransferSuccessView : UIViewController {
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferRecurringSuccessView = "TransferRecurringSuccessVC"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageView = "LandingPageVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferSuccessView")
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageView) as? LandingPageView else {
            fatalError("Failed to load LandingPage from TransferSuccessView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

