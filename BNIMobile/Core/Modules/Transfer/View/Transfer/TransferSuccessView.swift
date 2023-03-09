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
            fatalError("Failed to load LandingPage from TransferSuccessVC file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferRecurringSuccessView) as? TransferRecurringSuccessView else {
            fatalError("Failed to load Transfer from TransferSuccessView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

