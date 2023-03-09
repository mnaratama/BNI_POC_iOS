//
//  TransferRecurringSuccessView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class TransferRecurringSuccessView : UIViewController {
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageView = "LandingPageVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferRecurringSuccessView")
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageView) as? LandingPageView else {
            fatalError("Failed to load LandingPage from TransferRecurringSuccessVC file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    //    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
//        print("buttonTapped")
//        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferEnterDataView) as? TransferEnterDataView else {
//            fatalError("Failed to load Transfer from TransferEnterDataVC file")
//        }
//
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
    
}
