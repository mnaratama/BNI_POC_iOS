//
//  LandingPageView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class LandingPageView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferEnterDataView = "TransferEnterDataVC"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageModalBottomView = "LandingPageModalBottomVC"

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LandingPageView")
    }
    
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageModalBottomView) as? LandingPageModalBottomView else {
            fatalError("Failed to load landingPageModalBottomView from LandingPageView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
